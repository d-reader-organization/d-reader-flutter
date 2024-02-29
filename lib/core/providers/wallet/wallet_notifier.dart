import 'package:d_reader_flutter/core/providers/auth/auth_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/solana.dart' show Ed25519HDPublicKey;
part 'wallet_notifier.g.dart';

@riverpod
class WalletController extends _$WalletController {
  late StateController<GlobalState> globalNotifier;
  @override
  FutureOr<void> build() {
    globalNotifier = ref.read(globalStateProvider.notifier);
  }

  Future<void> connectWallet({
    required Function() onSuccess,
    required Function(String message) onFail,
    required Function(Object exception) onError,
  }) async {
    try {
      final result = await ref
          .read(solanaProvider.notifier)
          .authorizeAndSignMessage(null, () {
        globalNotifier.update(
          (state) => state.copyWith(
            isLoading: true,
          ),
        );
      });

      globalNotifier.update(
        (state) => state.copyWith(
          isLoading: false,
        ),
      );

      if (result != 'OK') {
        return onFail(result);
      }
      onSuccess();
    } catch (exception) {
      globalNotifier.update(
        (state) => state.copyWith(
          isLoading: false,
        ),
      );
      onError(exception);
    }
  }

  Future<void> handleWalletSelect({
    required String address,
    required Future<bool> Function() onAuthorizeNeeded,
  }) async {
    final walletAuthToken =
        ref.read(environmentNotifierProvider).wallets?[address]?.authToken;
    if (walletAuthToken == null) {
      final shouldAuthorize = await onAuthorizeNeeded();
      if (!shouldAuthorize) {
        return;
      }

      await ref.read(solanaProvider.notifier).authorizeIfNeededWithOnComplete();
      ref.read(selectedWalletProvider.notifier).update((state) =>
          ref.read(environmentNotifierProvider).publicKey?.toBase58() ??
          address);
      return ref.invalidate(userWalletsProvider);
    }
    ref.read(environmentNotifierProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            publicKey: Ed25519HDPublicKey.fromBase58(
              address,
            ),
            authToken: walletAuthToken,
          ),
        );
    ref.read(selectedWalletProvider.notifier).update(
          (state) => address,
        );
  }

  Future<void> handleDisconnectWallet({
    required String address,
    required void Function() callback,
  }) async {
    await ref.read(authRepositoryProvider).disconnectWallet(
          address: address,
        );
    final envState = ref.read(environmentNotifierProvider);
    envState.wallets?.removeWhere((key, value) => key == address);
    if (ref.read(environmentNotifierProvider).publicKey?.toBase58() ==
        address) {
      ref.read(environmentNotifierProvider.notifier).clearPublicKey();
    }
    ref.read(environmentNotifierProvider.notifier).putStateIntoLocalStore();
    ref.invalidate(userWalletsProvider);
    callback();
  }

  Future<void> handleUpdateWallet({
    required String address,
    required String label,
    required void Function(dynamic result) callback,
  }) async {
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );

    final result = await ref.read(walletRepositoryProvider).updateWallet(
          address: address,
          label: label,
        );
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );
    ref.invalidate(walletNameProvider);
    ref.invalidate(userWalletsProvider);
    callback(result);
  }

  Future<void> syncWallet({
    required String address,
    required void Function() callback,
  }) async {
    final notifier = ref.read(privateLoadingProvider.notifier);

    notifier.update((state) => true);
    await ref.read(syncWalletProvider(address).future);
    notifier.update((state) => false);
    ref.invalidate(userWalletsProvider);
    callback();
  }
}
