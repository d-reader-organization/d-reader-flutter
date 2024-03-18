import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/features/authentication/domain/providers/auth_provider.dart';
import 'package:d_reader_flutter/features/authentication/domain/repositories/auth_repository.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/sign_up_data_notifier.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/state/sign_up_data.dart';
import 'package:d_reader_flutter/routing/router.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_notifier.g.dart';

@riverpod
class SignUpNotifier extends _$SignUpNotifier {
  late final AuthRepository _authRepository;
  @override
  void build() {
    _authRepository = ref.watch(authRepositoryProvider);
  }

  Future<void> handleSignUpStep1({
    required String username,
    required Function() onSuccess,
    required Function(String message) onFail,
  }) async {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);

    final result =
        await ref.read(authRepositoryProvider).validateUsername(username);
    ref.read(globalNotifierProvider.notifier).updateLoading(false);

    result.fold(
      (failure) {
        onFail(failure.message);
      },
      (success) {
        ref.read(signUpDataNotifierProvider.notifier).updateUsername(username);
        onSuccess();
      },
    );
  }

  Future<void> handleResendVerification({
    required Function() callback,
  }) async {
    await _authRepository.requestEmailVerification().then((result) {
      result.fold((p0) => null, (p0) {
        callback();
      });
    });
  }

  Future<void> signUp({
    required SignUpData data,
    required Function() onSuccess,
    required Function(String message) onFail,
  }) async {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);
    final result = await _authRepository.signUp(
      email: data.email,
      password: data.password,
      username: data.username,
    );
    ref.read(globalNotifierProvider.notifier).updateLoading(false);
    result.fold((failure) {
      onFail(failure.message);
    }, (authTokens) async {
      ref.read(authRouteProvider.notifier).login();
      ref.read(environmentProvider.notifier).updateEnvironmentState(
            EnvironmentStateUpdateInput(
              jwtToken: authTokens.accessToken,
              refreshToken: authTokens.refreshToken,
            ),
          );
      final user = await ref.read(myUserProvider.future);
      ref.read(environmentProvider.notifier).updateEnvironmentState(
            EnvironmentStateUpdateInput(
              user: user,
            ),
          );
      onSuccess();
    });
  }
}
