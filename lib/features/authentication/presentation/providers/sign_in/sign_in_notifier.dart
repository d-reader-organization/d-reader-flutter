import 'package:d_reader_flutter/features/authentication/domain/providers/auth_provider.dart';
import 'package:d_reader_flutter/features/authentication/domain/repositories/auth_repository.dart';
import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/routing/router.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_notifier.g.dart';

@riverpod
class SignInController extends _$SignInController {
  late final AuthRepository _authRepository;

  @override
  void build() {
    // TODO Think about using AutoState if it's possible/worth.
    _authRepository = ref.watch(authRepositoryProvider);
  }

  Future<void> googleSignIn({
    required Function() onSuccess,
    required Function(String message) onFail,
  }) async {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);

    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final googleSignInResult = await googleSignIn.signIn();
      final accessToken =
          (await googleSignInResult?.authentication)?.accessToken;
      if (accessToken == null) {
        ref.read(globalNotifierProvider.notifier).updateLoading(false);
        return onFail('Failed to sign in with google.');
      }

      return await signIn(
        nameOrEmail: '',
        password: '',
        onSuccess: onSuccess,
        onFail: onFail,
        googleAccessToken: accessToken,
      );
    } catch (exception) {
      ref.read(globalNotifierProvider.notifier).updateLoading(false);
      onFail(exception.toString());
    }
  }

  Future<void> signIn({
    required String nameOrEmail,
    required String password,
    required Function() onSuccess,
    required Function(String message) onFail,
    String? googleAccessToken,
  }) async {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);
    final response = googleAccessToken != null
        ? await _authRepository.googleSignIn(accessToken: googleAccessToken)
        : await _authRepository.signIn(
            nameOrEmail: nameOrEmail,
            password: password,
          );

    response.fold(
      (failure) {
        ref.read(globalNotifierProvider.notifier).updateLoading(false);
        onFail(failure.message);
      },
      (authTokens) async {
        ref.read(environmentProvider.notifier).updateEnvironmentState(
              EnvironmentStateUpdateInput(
                jwtToken: authTokens.accessToken,
                refreshToken: authTokens.refreshToken,
              ),
            );
        await ref.read(myUserProvider.future);
        ref.read(globalNotifierProvider.notifier).updateLoading(false);
        ref.read(authRouteProvider).login();
        onSuccess();
      },
    );
  }
}
