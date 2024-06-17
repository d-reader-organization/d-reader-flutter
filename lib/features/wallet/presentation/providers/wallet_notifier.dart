import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/authentication/domain/providers/auth_provider.dart';
import 'package:d_reader_flutter/features/user/domain/providers/user_provider.dart';
import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/features/wallet/domain/providers/wallet_provider.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_wallet_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/mwa_notifier.dart';
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
        .read(mwaNotifierProvider.notifier)
        .authorizeIfNeededWithOnComplete(
            isConnectOnly: true,
            onStart: () {
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
      if (result != successResult) {
        onFail(result);
      }
      onSuccess();
    });
  }

  Future<bool> handleWalletSelect({
    required String address,
    required Future<bool> Function() onAuthorizeNeeded,
  }) async {
    final walletAuthToken =
        ref.read(environmentProvider).walletAuthTokenMap?[address];
    if (walletAuthToken == null) {
      final shouldAuthorize = await onAuthorizeNeeded();
      if (!shouldAuthorize) {
        return false;
      }

      await ref
          .read(mwaNotifierProvider.notifier)
          .authorizeIfNeededWithOnComplete();

      ref.invalidate(userWalletsProvider);
      return true;
    }
    ref.read(environmentProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            publicKey: Ed25519HDPublicKey.fromBase58(
              address,
            ),
            authToken: walletAuthToken,
          ),
        );

    return true;
  }

  Future<void> handleDisconnectWallet({
    required String address,
    required void Function() callback,
  }) async {
    await ref.read(authRepositoryProvider).disconnectWallet(
          address: address,
        );
    final envState = ref.read(environmentProvider);
    envState.walletAuthTokenMap?.removeWhere((key, value) => key == address);
    if (ref.read(environmentProvider).publicKey?.toBase58() == address) {
      ref.read(environmentProvider.notifier).clearPublicKey();
    }
    if (address == ref.read(localWalletNotifierProvider).value?.address) {
      await ref.read(localWalletNotifierProvider.notifier).deleteWallet();
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
    result.fold(
      (exception) {
        callback(exception.message);
      },
      (wallet) {
        ref.invalidate(walletNameProvider);
        ref.invalidate(userWalletsProvider);
        callback(wallet);
      },
    );
  }

  Future<void> handleSyncWallets({required void Function() afterSync}) async {
    await ref
        .read(userRepositoryProvider)
        .syncWallets(ref.watch(environmentProvider).user!.id)
        .then((value) {
      ref.invalidate(userWalletsProvider);
      afterSync();
    });
  }
}
