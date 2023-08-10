import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/providers/dio/dio_provider.dart';
import 'package:d_reader_flutter/core/repositories/user/repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_provider.g.dart';

@riverpod
UserRepositoryImpl userRepository(UserRepositoryRef ref) {
  return UserRepositoryImpl(
    client: ref.watch(dioProvider),
  );
}

@riverpod
Future<UserModel?> myUser(MyUserRef ref) async {
  final UserModel? user = await ref.read(userRepositoryProvider).myUser();
  return user;
}

@riverpod
Future<void> resetPassword(
  ResetPasswordRef ref, {
  required String id,
}) async {
  await ref.read(userRepositoryProvider).resetPassword(
        id,
      );
}

@riverpod
Future<void> requestEmailVerification(RequestEmailVerificationRef ref) async {
  await ref.read(userRepositoryProvider).requestEmailVerification();
}

@riverpod
Future<void> verifyEmail(
  VerifyEmailRef ref, {
  required String verificationToken,
}) async {
  await ref
      .read(userRepositoryProvider)
      .verifyEmail(verificationToken: verificationToken);
}

final usernameTextProvider = StateProvider<String>(
  (ref) {
    return '';
  },
);
