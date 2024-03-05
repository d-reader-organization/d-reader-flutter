import 'package:d_reader_flutter/shared/domain/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      onException(exception);
    }, (result) {
      if (result != 'OK') {
        onFail(result);
      }
      onSuccess();
    });
  }
}
