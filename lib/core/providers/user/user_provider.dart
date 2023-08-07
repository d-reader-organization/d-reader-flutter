import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/providers/dio/dio_provider.dart';
import 'package:d_reader_flutter/core/repositories/user/repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_provider.g.dart';

final userRepositoryProvider = Provider<UserRepositoryImpl>(
  (ref) {
    return UserRepositoryImpl(
      client: ref.watch(dioProvider),
    );
  },
);

@riverpod
Future<UserModel?> myUser(MyUserRef ref) async {
  final UserModel? user = await ref.read(userRepositoryProvider).myUser();
  return user;
}
