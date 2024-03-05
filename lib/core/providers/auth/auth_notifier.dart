import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/features/user/domain/providers/user_provider.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_notifier.g.dart';

@riverpod
class AuthController extends _$AuthController {
  late StateController<GlobalState> globalNotifier;
  @override
  FutureOr<void> build() {
    globalNotifier = ref.read(globalStateProvider.notifier);
  }

  Future<void> handleRequestResetPassword({
    required String email,
    required Function() onSuccess,
    required Function(String cause) onException,
  }) async {
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    try {
      await ref.read(userRepositoryProvider).requestPasswordReset(email);
      globalNotifier.update(
        (state) => state.copyWith(
          isLoading: false,
        ),
      );
      onSuccess();
    } catch (exception) {
      globalNotifier.update(
        (state) => state.copyWith(
          isLoading: false,
        ),
      );
      if (exception is BadRequestException) {
        onException(exception.cause);
      }
    }
  }
}
