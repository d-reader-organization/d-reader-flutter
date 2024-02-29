import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/models/wallet_asset.dart';
import 'package:d_reader_flutter/core/providers/dio/dio_provider.dart';
import 'package:d_reader_flutter/core/repositories/user/repository_impl.dart';
import 'package:d_reader_flutter/shared/domain/models/user.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
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
  ref.read(environmentProvider.notifier).updateEnvironmentState(
        EnvironmentStateUpdateInput(
          user: user,
        ),
      );
  return user;
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

@riverpod
Future<List<WalletAsset>> userAssets(
  Ref ref, {
  required int id,
}) {
  return ref.read(userRepositoryProvider).userAssets(id);
}

final oldPasswordProvider = StateProvider.autoDispose<String>(
  (ref) {
    return '';
  },
);

final newPasswordProvider = StateProvider.autoDispose<String>(
  (ref) {
    return '';
  },
);
