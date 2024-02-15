import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
}
