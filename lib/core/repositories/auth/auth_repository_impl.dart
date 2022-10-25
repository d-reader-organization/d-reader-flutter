import 'package:d_reader_flutter/core/repositories/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<bool> signIn() async {
    return true;
  }

  @override
  Future<bool> signOut() async {
    return true;
  }
}
