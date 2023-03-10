import 'dart:io';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
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

  Future<String?> apiCallPatch(String path, [Object? body]) async {
    Uri uri = Uri.parse('$apiUrl$path');
    await _setTokenIfNeeded();
    http.Response response = await http.patch(
      uri,
      headers: {HttpHeaders.authorizationHeader: '$_token'},
      body: body,
    );
    if (response.statusCode != 200) {
      print(response.body);
      return null;
    }
    return response.body;
  }

  Future<String?> apiMultipartRequest(
      String path, UpdateAvatarPayload payload) async {
    try {
      Uri uri = Uri.parse('$apiUrl$path');
      final sp = await SharedPreferences.getInstance();
      final _token = sp.getString(Config.tokenKey);
      var request = http.MultipartRequest('PATCH', uri)
        ..headers.addAll({HttpHeaders.authorizationHeader: '$_token'})
        ..files.add(payload.avatar);
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      return responseBody;
    } catch (error) {
      print(error.toString());
    }
    return null;
  }

  Future<void> _setTokenIfNeeded() async {
    if (_token == null) {
      final sp = await SharedPreferences.getInstance();
      _token ??= sp.getString(Config.tokenKey);
    }
  }
}
