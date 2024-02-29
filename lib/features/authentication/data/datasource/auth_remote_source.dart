import 'package:d_reader_flutter/features/authentication/domain/models/authorization_response.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/exceptions/app_exception.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthDataSource {
  Future<Either<AppException, AuthorizationResponse>> signIn({
    required String nameOrEmail,
    required String password,
  });

  Future<Either<AppException, AuthorizationResponse>> signUp({
    required String email,
    required String password,
    required String username,
  });
}

class AuthRemoteDataSource implements AuthDataSource {
  final NetworkService networkService;

  AuthRemoteDataSource(this.networkService);

  @override
  Future<Either<AppException, AuthorizationResponse>> signIn({
    required String nameOrEmail,
    required String password,
  }) async {
    try {
      final signInResult =
          await networkService.patch('/auth/user/login', data: {
        'nameOrEmail': nameOrEmail,
        'password': password,
      });
      return signInResult.fold(
        (exception) {
          return Left(exception);
        },
        (response) {
          final authorizationResponse =
              AuthorizationResponse.fromJson(response.data);

          networkService.updateHeader(
            {'Authorization': authorizationResponse.accessToken},
          );

          return Right(authorizationResponse);
        },
      );
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier: '${exception.toString()}AuthRemoteDataSource.signIn',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, AuthorizationResponse>> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final signUpResult =
          await networkService.post('/auth/user/register', data: {
        'email': email,
        'password': password,
        'name': username,
      });
      return signUpResult.fold((exception) {
        return Left(exception);
      }, (response) {
        final authorizationResponse =
            AuthorizationResponse.fromJson(response.data);
        networkService.updateHeader(
          {'Authorization': authorizationResponse.accessToken},
        );

        return Right(authorizationResponse);
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier: '${exception.toString()}AuthRemoteDataSource.signUp',
        ),
      );
    }
  }
}
