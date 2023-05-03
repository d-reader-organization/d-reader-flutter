import 'dart:convert' show jsonDecode;
import 'dart:io';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/api_error.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/ioc.dart';

import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  String _apiUrl = Config.apiUrl;
  String? _token;
  SharedPreferences? _sharedPreferences;
  static ApiService get instance => IoCContainer.resolveContainer<ApiService>();

  Future<String?> apiCallGet(
    String path, {
    bool includeAuthHeader = true,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      await _setters();
      Uri uri = queryParameters != null
          ? Uri.https(
              _apiUrl.replaceAll('https://', ''),
              path,
              queryParameters,
            )
          : Uri.parse('$_apiUrl$path');
      http.Response response = await http.get(
        uri,
        headers: includeAuthHeader
            ? {HttpHeaders.authorizationHeader: '$_token'}
            : {},
      );
      if (response.statusCode != 200) {
        Sentry.captureMessage(
          'Api call GET on $path has ${response.statusCode} with message ${response.body}',
          level: SentryLevel.error,
        );
        return null;
      }
      return response.body;
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      return null;
    }
  }

  Future<String?> apiCallPost(String path) async {
    Uri uri = Uri.parse('$_apiUrl$path');
    await _setters();
    try {
      http.Response response = await http.post(
        uri,
        headers: {HttpHeaders.authorizationHeader: '$_token'},
      );
      if (response.statusCode != 200) {
        Sentry.captureMessage(
          'Api call POST on $path has ${response.statusCode} with message ${response.body}',
          level: SentryLevel.error,
        );
      }
      return response.body;
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      return null;
    }
  }

  Future<dynamic> apiCallPatch(
    String path, {
    bool includeAuthHeader = true,
    Object? body,
  }) async {
    try {
      Uri uri = Uri.parse('$_apiUrl$path');
      await _setters();

      http.Response response = await http.patch(
        uri,
        headers: includeAuthHeader
            ? {HttpHeaders.authorizationHeader: '$_token'}
            : {},
        body: body,
      );

      if (response.statusCode != 200) {
        final decodedBody = jsonDecode(response.body);
        throw ApiError(
          error: decodedBody['error'],
          message: decodedBody['message'] is List
              ? decodedBody['message'].join('. ')
              : decodedBody['message'],
          statusCode: decodedBody['statusCode'] ?? 500,
        );
      }
      return response.body;
    } on ApiError catch (error) {
      Sentry.captureException(error);
      return error;
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      return null;
    }
  }

  Future<String?> apiMultipartRequest(
      String path, UpdateWalletPayload payload) async {
    try {
      if (payload.avatar == null) {
        return null;
      }
      Uri uri = Uri.parse('$_apiUrl$path');
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString(Config.tokenKey);
      var request = http.MultipartRequest('PATCH', uri)
        ..headers.addAll({HttpHeaders.authorizationHeader: '$token'})
        ..files.add(payload.avatar!);
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      return responseBody;
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
    }
    return null;
  }

  _setters() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _setToken();
    _setApiUrl();
  }

  _setToken() {
    _token = _sharedPreferences?.getString(Config.tokenKey);
  }

  _setApiUrl() {
    final lastNetwork = _sharedPreferences?.getString('temp-network') ??
        _sharedPreferences?.getString('last-network');
    _apiUrl = lastNetwork == SolanaCluster.devnet.value
        ? Config.apiUrlDevnet
        : Config.apiUrl;
  }
}
