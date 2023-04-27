import 'package:d_reader_flutter/core/models/auth.dart';

abstract class AuthRepository {
  Future<dynamic> getOneTimePassword({
    required String address,
    required String name,
    String? referrer,
  });
  Future<AuthWallet?> connectWallet(String address, String encoding);
}
