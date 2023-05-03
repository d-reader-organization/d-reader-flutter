import 'package:d_reader_flutter/core/models/auth.dart';

abstract class AuthRepository {
  Future<dynamic> getOneTimePassword({
    required String address,
  });
  Future<AuthWallet?> connectWallet(String address, String encoding);
}
