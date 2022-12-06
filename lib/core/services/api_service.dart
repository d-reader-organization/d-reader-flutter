import 'dart:io';

import 'package:d_reader_flutter/config/config.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String apiUrl = Config.apiUrl;

  static Future<String?> apiCallGet(String path,
      {bool includeAuthHeader = true}) async {
    Uri uri = Uri.parse('$apiUrl$path');
    http.Response response = await http.get(uri,
        headers: includeAuthHeader
            ? {HttpHeaders.authorizationHeader: 'Bearer ${Config.jwtToken}'}
            : {});
    if (response.statusCode != 200) {
      print(response.body);
      return null;
    }
    return response.body;
  }

  static Future<void> apiCallPatch(String path) async {
    Uri uri = Uri.parse('$apiUrl$path');
    http.Response response = await http.patch(
      uri,
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${Config.jwtToken}'},
    );
    if (response.statusCode != 200) {
      print(response.body);
    }
  }
}
