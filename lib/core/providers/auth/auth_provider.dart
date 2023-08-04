import 'package:d_reader_flutter/core/providers/dio_provider.dart';
import 'package:d_reader_flutter/core/repositories/auth/auth_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl(client: ref.watch(dioProvider));
});
