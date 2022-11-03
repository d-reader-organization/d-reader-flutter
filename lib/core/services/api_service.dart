import 'dart:convert';
import 'dart:io';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/auth.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String API_URL = Config.API_URL;

  static Future<String> getOneTimePassword(String address) async {
    Uri authAddressUri =
        Uri.parse('$API_URL/auth/wallet/request-password/$address');
    http.Response response = await http.get(authAddressUri);
    return response.statusCode == 200 ? response.body : 'An error occured';
  }

  static Future<AuthWallet?> connectWallet(
      String address, String encoding) async {
    Uri connectWalletUri =
        Uri.parse('$API_URL/auth/wallet/connect/$address/$encoding');
    http.Response response = await http.get(connectWalletUri);
    if (response.statusCode != 200) {
      print(response.body);
      return null;
    }
    return AuthWallet.fromJson(jsonDecode(response.body));
  }

  static Future<String?> apiCallGet(String path) async {
    Uri uri = Uri.parse('$API_URL$path');
    http.Response response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${Config.jwtToken}'
    });
    if (response.statusCode != 200) {
      print(response.body);
      return null;
    }
    return response.body;
  }
}
