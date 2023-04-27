import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/auth.dart';
import 'package:d_reader_flutter/core/repositories/auth/auth_repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> getOneTimePassword({
    required String address,
    String? name,
    String? referrer,
  }) async {
    String? responseBody = await ApiService.instance
        .apiCallPatch('/auth/wallet/request-password/$address', {
      "address": address,
      "name": name,
      "referrer": referrer,
    });
    return responseBody ?? 'An error occured';
  }

  @override
  Future<AuthWallet?> connectWallet(String address, String encoding) async {
    String? responseBody = await ApiService.instance.apiCallGet(
      '/auth/wallet/connect/$address/$encoding',
      includeAuthHeader: false,
    );
    return responseBody != null
        ? AuthWallet.fromJson(jsonDecode(responseBody))
        : null;
  }
}
