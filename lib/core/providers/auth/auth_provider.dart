import 'package:d_reader_flutter/core/models/auth.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/auth/sign_up_notifier.dart';
import 'package:d_reader_flutter/core/providers/dio/dio_provider.dart';
import 'package:d_reader_flutter/core/repositories/auth/auth_repository_impl.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_provider.g.dart';

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl(client: ref.watch(dioProvider));
});

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
    ref.read(environmentProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            jwtToken: result.accessToken,
            refreshToken: result.refreshToken,
          ),
        );
    return true;
  }
  return result is String ? result : 'Failed to register user.';
}
