import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
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
Future<List<WalletModel>> userWallets(
  UserWalletsRef ref, {
  required int? id,
}) async {
  if (id != null) {
    return ref.read(userRepositoryProvider).userWallets(id);
  }
  return [];
}

final usernameTextProvider = StateProvider<String>(
  (ref) {
    return '';
  },
);
