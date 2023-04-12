import 'dart:io';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/ioc.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String apiUrl = Config.devApiUrl;
  String? _token;

  static ApiService get instance => IoCContainer.resolveContainer<ApiService>();

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
      String path, UpdateWalletPayload payload) async {
    try {
      if (payload.avatar == null) {
        return null;
      }
      Uri uri = Uri.parse('$apiUrl$path');
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString(Config.tokenKey);
      var request = http.MultipartRequest('PATCH', uri)
        ..headers.addAll({HttpHeaders.authorizationHeader: '$token'})
        ..files.add(payload.avatar!);
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
