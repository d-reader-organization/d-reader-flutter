import 'dart:convert';

import 'package:d_reader_flutter/config/config.dart';
import 'package:http/http.dart' as http;

class ConnectWalletResponse {
  String accessToken;
  String refreshToken;

  ConnectWalletResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory ConnectWalletResponse.fromJson(json) {
    return ConnectWalletResponse(
        accessToken: json['accessToken'], refreshToken: json['refreshToken']);
  }
}

class ApiService {
  static final String API_URL = Config.API_URL;

  static Future<String> getOneTimePassword(String address) async {
    Uri authAddressUri =
        Uri.parse('$API_URL/auth/wallet/request-password/$address');
    http.Response response = await http.get(authAddressUri);
    return response.statusCode == 200 ? response.body : 'An error occured';
  }

  static Future<ConnectWalletResponse?> connectWallet(
      String address, String encoding) async {
    Uri connectWalletUri =
        Uri.parse('$API_URL/auth/wallet/connect/$address/$encoding');
    http.Response response = await http.get(connectWalletUri);
    if (response.statusCode != 200) {
      print(response.body);
      return null;
    }
    return ConnectWalletResponse.fromJson(jsonDecode(response.body));
  }
}
