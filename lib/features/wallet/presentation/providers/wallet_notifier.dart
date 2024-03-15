import 'package:d_reader_flutter/features/authentication/domain/providers/auth_provider.dart';
import 'package:d_reader_flutter/features/user/presentations/providers/user_providers.dart';
import 'package:d_reader_flutter/features/wallet/domain/providers/wallet_provider.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/solana.dart';

part 'wallet_notifier.g.dart';

@riverpod
class WalletController extends _$WalletController {
  @override
  void build() {}

  Future<void> connectWallet({
    required Function() onSuccess,
    required Function(String message) onFail,
    required Function(Object exception) onException,
  }) async {
    final authorizeResult = await ref
        .read(solanaNotifierProvider.notifier)
        .authorizeIfNeededWithOnComplete(onStart: () {
      ref.read(globalNotifierProvider.notifier).updateLoading(true);
    });
    ref.read(globalNotifierProvider.notifier).updateLoading(false);
    authorizeResult.fold((exception) {
      if (exception is NoWalletFoundException) {
        return onException(exception);
      } else if (exception is LowPowerModeException) {
        return onException(exception);
      }
      onFail(exception.message);
    }, (result) {
      if (result != 'OK') {
        onFail(result);
      }
      onSuccess();
    });
  }

  Future<void> handleWalletSelect({
    required String address,
    required Future<bool> Function() onAuthorizeNeeded,
  }) async {
    final walletAuthToken =
        ref.read(environmentProvider).wallets?[address]?.authToken;
    if (walletAuthToken == null) {
      final shouldAuthorize = await onAuthorizeNeeded();
      if (!shouldAuthorize) {
        return;
      }

      await ref
          .read(solanaNotifierProvider.notifier)
          .authorizeIfNeededWithOnComplete();
      ref.read(selectedWalletProvider.notifier).update((state) =>
          ref.read(environmentProvider).publicKey?.toBase58() ?? address);
      return ref.invalidate(userWalletsProvider);
    }
    ref.read(environmentProvider.notifier).updateEnvironmentState(
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
    final envState = ref.read(environmentProvider);
    envState.wallets?.removeWhere((key, value) => key == address);
    if (ref.read(environmentProvider).publicKey?.toBase58() == address) {
      ref.read(environmentProvider.notifier).clearPublicKey();
    }
    ref.read(environmentProvider.notifier).putStateIntoLocalStore();
    ref.invalidate(userWalletsProvider);
    callback();
  }

  Future<void> handleUpdateWallet({
    required String address,
    required String label,
    required void Function(dynamic result) callback,
  }) async {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);

    final result = await ref.read(walletRepositoryProvider).updateWallet(
          address: address,
          label: label,
        );
    ref.read(globalNotifierProvider.notifier).updateLoading(false);
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
    await ref.read(walletRepositoryProvider).syncWallet(address);
    notifier.update((state) => false);
    ref.invalidate(userWalletsProvider);
    callback();
  }
}
