import 'package:d_reader_flutter/core/models/auth.dart';

abstract class AuthRepository {
  Future<String> getOneTimePassword({
    required String address,
    String? name,
    String? referrer,
  });
  Future<AuthWallet?> connectWallet(String address, String encoding);
}
