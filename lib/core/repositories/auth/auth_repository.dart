import 'package:d_reader_flutter/core/models/auth.dart';

abstract class AuthRepository {
  Future<dynamic> getOneTimePassword({
    required String address,
    required String apiUrl,
  });
  Future<AuthSignInResponse?> connectWallet({
    required String address,
    required String encoding,
    required String apiUrl,
  });
  Future<void> disconnectWallet({
    required String address,
    required String apiUrl,
  });

  Future<dynamic>? signIn({
    required String nameOrEmail,
    required String password,
  });
}
