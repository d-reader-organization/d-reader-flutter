import 'package:d_reader_flutter/core/models/exceptions.dart';
import 'package:d_reader_flutter/core/providers/auth/auth_provider.dart';
import 'package:d_reader_flutter/core/providers/auth/sign_up_notifier.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
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

  Future<void> signIn({
    required String nameOrEmail,
    required String password,
    required Function() onSuccess,
    required Function(String? message) onFail,
  }) async {
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    final response = await ref.read(
      signInProvider(
        nameOrEmail: nameOrEmail,
        password: password,
      ).future,
    );

    if (response is String) {
      globalNotifier.update(
        (state) => state.copyWith(
          isLoading: false,
        ),
      );
      return onFail(response);
    }
    final user = await ref.read(myUserProvider.future);
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );
    ref.read(environmentNotifierProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            user: user,
          ),
        );
    onSuccess();
  }

  Future<void> handleSignUpStep1({
    required String username,
    required Function() onSuccess,
    required Function(String message) onFail,
  }) async {
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    final result =
        await ref.read(authRepositoryProvider).validateUsername(username);
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );
    if (result is String) {
      return onFail(result);
    }
    ref.read(signUpDataProvider.notifier).updateUsername(username);
    onSuccess();
  }

  Future<void> handleResendVerification({
    required Function() callback,
  }) async {
    await ref.read(requestEmailVerificationProvider.future);
    callback();
  }

  Future<void> signUp({
    required Function() onSuccess,
    required Function(String message) onFail,
  }) async {
    final notifier = ref.read(globalStateProvider.notifier);
    notifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    final result = await ref.read(signUpFutureProvider.future);
    final bool isSuccess = result is bool && result;

    notifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );
    isSuccess ? onSuccess() : onFail(result);
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
