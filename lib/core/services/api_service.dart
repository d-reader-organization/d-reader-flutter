import 'dart:io';

import 'package:d_reader_flutter/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final String apiUrl = Config.apiUrl;
  String? _token;

  Future<String?> apiCallGet(String path,
      {bool includeAuthHeader = true}) async {
    await _setTokenIfNeeded();
    Uri uri = Uri.parse('$apiUrl$path');
    http.Response response = await http.get(uri,
        headers: includeAuthHeader
            ? {HttpHeaders.authorizationHeader: '$_token'}
            : {});
    if (response.statusCode != 200) {
      print(response.body);
      return null;
    }
    return response.body;
  }

  Future<String?> apiCallPost(String path) async {
    Uri uri = Uri.parse('$apiUrl$path');
    await _setTokenIfNeeded();
    http.Response response = await http.post(
      uri,
      headers: {HttpHeaders.authorizationHeader: '$_token'},
    );
    if (response.statusCode != 200) {
      print(response.body);
    }
    return response.body;
  }

  Future<void> apiCallPatch(String path) async {
    Uri uri = Uri.parse('$apiUrl$path');
    await _setTokenIfNeeded();
    http.Response response = await http.patch(
      uri,
      headers: {HttpHeaders.authorizationHeader: '$_token'},
    );
    if (response.statusCode != 200) {
      print(response.body);
    }
  }

  Future<void> _setTokenIfNeeded() async {
    if (_token == null) {
      final sp = await SharedPreferences.getInstance();
      _token ??= sp.getString(Config.tokenKey);
    }
  }
}
