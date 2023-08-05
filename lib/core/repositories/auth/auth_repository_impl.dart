import 'package:d_reader_flutter/core/models/auth.dart';
import 'package:d_reader_flutter/core/repositories/auth/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio client;

  AuthRepositoryImpl({
    required this.client,
  });

  @override
  Future<dynamic> getOneTimePassword({
    required String address,
    required String apiUrl,
  }) async {
    final Dio dio = Dio(BaseOptions(baseUrl: apiUrl));
    final response = await dio
        .patch('/auth/wallet/request-password/$address')
        .then((value) => value.data);
    dio.close();

    return response;
  }

  @override
  Future<AuthorizationResponse?> connectWallet({
    required String address,
    required String encoding,
    required String apiUrl,
  }) async {
    try {
      final Dio dio = Dio(BaseOptions(baseUrl: apiUrl));
      final response = await dio
          .get('/auth/wallet/connect/$address/$encoding')
          .then((value) => value.data);
      dio.close();
      return response != null
          ? AuthorizationResponse.fromJson(response)
          : null; // TODO: we don't get authorization from this anymore
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<AuthorizationResponse?> disconnectWallet({
    required String address,
    required String apiUrl,
  }) async {
    try {
      final Dio dio = Dio(BaseOptions(baseUrl: apiUrl));
      final response = await dio
          .get('/auth/wallet/disconnect/$address')
          .then((value) => value.data);
      dio.close();
      return response != null
          ? AuthorizationResponse.fromJson(response)
          : null; // TODO: we don't get authorization here as well
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<dynamic>? signIn({
    required String nameOrEmail,
    required String password,
  }) async {
    try {
      final response = await client.post('/auth/user/login', data: {
        'nameOrEmail': nameOrEmail,
        'password': password,
      }).then((value) => value.data);
      return response != null ? AuthorizationResponse.fromJson(response) : null;
    } catch (exception, stackTrace) {
      if (exception is DioError) {
        final dynamic message = exception.response?.data?['message'];
        return message != null
            ? message is List
                ? message.join('. ')
                : message
            : exception.response?.data.toString();
      }
      Sentry.captureException(exception, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future? signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await client.post('/auth/user/register', data: {
        'email': email,
        'password': password,
        'name': username,
      }).then((value) => value.data);

      return response != null ? AuthorizationResponse.fromJson(response) : null;
    } catch (exception, stackTrace) {
      if (exception is DioError) {
        final dynamic message = exception.response?.data?['message'];
        return message != null
            ? message is List
                ? message.join('. ')
                : message
            : exception.response?.data.toString();
      }
      Sentry.captureException(exception, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<String>? refreshToken(String refreshToken) {
    return client
        .get('/auth/user/refresh-token/$refreshToken')
        .then((value) => value.data);
  }
}
