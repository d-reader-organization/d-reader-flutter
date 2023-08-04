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

  // TODO: missing /user/login | /user/register /user/refresh-token

  @override
  Future<AuthSignInResponse?> connectWallet({
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
          ? AuthSignInResponse.fromJson(response)
          : null; // TODO: we don't get authorization from this anymore
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<AuthSignInResponse?> disconnectWallet({
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
          ? AuthSignInResponse.fromJson(response)
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
      return response != null ? AuthSignInResponse.fromJson(response) : null;
    } catch (exception, stackTrace) {
      if (exception is DioError) {
        return exception.response?.data?['message'] ??
            exception.response?.data.toString();
      }
      Sentry.captureException(exception, stackTrace: stackTrace);
      return null;
    }
  }
}
