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
    required String jwtToken,
  }) async {
    final Dio dio = Dio(BaseOptions(baseUrl: apiUrl));
    final response = await dio
        .patch(
          '/auth/wallet/request-password/$address',
          options: Options(
            headers: {
              'Authorization': jwtToken,
            },
          ),
        )
        .then((value) => value.data);
    dio.close();

    return response;
  }

  @override
  Future<void> connectWallet({
    required String address,
    required String encoding,
    required String apiUrl,
    required String jwtToken,
  }) async {
    try {
      final Dio dio = Dio(BaseOptions(baseUrl: apiUrl));
      await dio
          .patch(
            '/auth/wallet/connect/$address/$encoding',
            options: Options(
              headers: {
                'Authorization': jwtToken,
              },
            ),
          )
          .then((value) => value.data);
      dio.close();
    } catch (exception) {
      Sentry.captureException(exception,
          stackTrace: 'Failed to connect wallet with address $address');
      rethrow;
    }
  }

  @override
  Future<void> disconnectWallet({
    required String address,
  }) {
    return client
        .patch('/auth/wallet/disconnect/$address')
        .then((value) => value.data);
  }

  @override
  Future<dynamic>? signIn({
    required String nameOrEmail,
    required String password,
  }) async {
    try {
      final response = await client.patch('/auth/user/login', data: {
        'nameOrEmail': nameOrEmail,
        'password': password,
      }).then((value) => value.data);
      return response != null ? AuthorizationResponse.fromJson(response) : null;
    } catch (exception, stackTrace) {
      if (exception is DioException) {
        final dynamic message = exception.response?.data?['message'];
        return message != null
            ? message is List
                ? message.join('. ')
                : message
            : exception.response?.data.toString();
      }
      Sentry.captureException(
        exception,
        stackTrace: 'Failed to sign in $stackTrace',
      );
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
      if (exception is DioException) {
        final dynamic message = exception.response?.data?['message'];
        return message != null
            ? message is List
                ? message.join('. ')
                : message
            : exception.response?.data.toString();
      }
      Sentry.captureException(
        exception,
        stackTrace: 'Failed to sign up $stackTrace',
      );
      return null;
    }
  }

  @override
  Future<String>? refreshToken(String refreshToken) {
    return client
        .patch('/auth/user/refresh-token/$refreshToken')
        .then((value) => value.data);
  }

  @override
  Future<dynamic> validateUsername(String username) async {
    try {
      await client.get('/auth/user/validate-name/$username');
      return true;
    } catch (exception) {
      if (exception is! DioException) {
        return 'Username already taken.';
      }
      final dynamic message = exception.response?.data?['message'];
      return message != null
          ? message is List
              ? message.join('. ')
              : message
          : exception.response?.data.toString();
    }
  }
}
