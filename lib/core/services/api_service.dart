import 'dart:io';

import 'package:d_reader_flutter/config/config.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String API_URL = Config.API_URL;

  static Future<String?> apiCallGet(String path,
      {bool includeAuthHeader = true}) async {
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
