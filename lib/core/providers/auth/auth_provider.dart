import 'package:d_reader_flutter/core/models/auth.dart';
import 'package:d_reader_flutter/core/providers/auth/sign_up_notifier.dart';
import 'package:d_reader_flutter/core/providers/dio/dio_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/core/repositories/auth/auth_repository_impl.dart';
import 'package:d_reader_flutter/routing/router.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_provider.g.dart';

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl(client: ref.watch(dioProvider));
});

@riverpod
Future<dynamic> signIn(
  SignInRef ref, {
  required String nameOrEmail,
  required String password,
}) async {
  final result = await ref.read(authRepositoryProvider).signIn(
        nameOrEmail: nameOrEmail,
        password: password,
      );
  if (result is AuthorizationResponse) {
    ref.read(authRouteProvider).login();
    return ref
        .read(environmentNotifierProvider.notifier)
        .updateEnvironmentState(
          EnvironmentStateUpdateInput(
            jwtToken: result.accessToken,
            refreshToken: result.refreshToken,
          ),
        );
  }
  return result ?? 'Failed to login.';
}

@riverpod
Future<dynamic> signUpFuture(
  SignUpFutureRef ref,
) async {
  final signUpData = ref.read(signUpDataProvider);
  final result = await ref.read(authRepositoryProvider).signUp(
        email: signUpData.email,
        password: signUpData.password,
        username: signUpData.username,
      );
  if (result is AuthorizationResponse) {
    ref.read(authRouteProvider.notifier).login();
    ref.read(environmentNotifierProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            jwtToken: result.accessToken,
            refreshToken: result.refreshToken,
          ),
        );
    final user = await ref.read(userRepositoryProvider).myUser();
    ref.read(environmentNotifierProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            user: user,
          ),
        );
    return true;
  }
  return result is String ? result : 'Failed to register user.';
}
