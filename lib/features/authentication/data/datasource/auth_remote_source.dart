import 'package:d_reader_flutter/features/authentication/domain/models/authorization_response.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

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
  Future<Either<AppException, bool>> validateUsername(String username);
  Future<Either<AppException, bool>> requestEmailVerification();
  Future<Either<AppException, bool>> connectWallet({
    required String address,
    required String encoding,
  });
  Future<Either<AppException, String>> getOneTimePassword({
    required String address,
  });

  Future<void> disconnectWallet(String address);
  Future<String> refreshToken(String token);
  Future<Either<AppException, dynamic>> googleSignIn(
      {required String accessToken});
  Future<Either<AppException, AuthorizationResponse>> googleSignUp({
    required String accessToken,
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

  @override
  Future<Either<AppException, bool>> validateUsername(String username) async {
    try {
      final result =
          await networkService.get('/auth/user/validate-name/$username');
      return result.fold((exception) {
        return Left(exception);
      }, (res) {
        return const Right(true);
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occured',
          statusCode: 500,
          identifier:
              '${exception.toString()}-AuthRemoteDataSource.validateUsername',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, bool>> requestEmailVerification() async {
    return await networkService.patch('/user/request-email-verification').then(
          (value) => value.fold(
            (exception) => Left(exception),
            (value) => const Right(true),
          ),
        );
  }

  @override
  Future<Either<AppException, bool>> connectWallet({
    required String address,
    required String encoding,
  }) async {
    try {
      await networkService.patch('/auth/wallet/connect', data: {
        'address': address,
        'encoding': encoding,
        'signedDataType': 'Message'
      });
      return const Right(true);
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occured',
          statusCode: 500,
          identifier:
              '${exception.toString()}-AuthRemoteDataSource.connectWallet',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, String>> getOneTimePassword({
    required String address,
  }) async {
    try {
      final response =
          await networkService.patch('/auth/wallet/request-password/$address');
      return response.fold(
        (exception) {
          return Left(exception);
        },
        (oneTimePassword) {
          return Right(oneTimePassword.data.toString());
        },
      );
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occured',
          statusCode: 500,
          identifier:
              '${exception.toString()}-AuthRemoteDataSource.getOneTimePassword',
        ),
      );
    }
  }

  @override
  Future<void> disconnectWallet(String address) {
    return networkService.patch('/auth/wallet/disconnect/$address');
  }

  @override
  Future<String> refreshToken(String token) {
    return networkService
        .patch('/auth/user/refresh-token/$token')
        .then((value) => value.fold((p0) => '', (p0) => p0.data));
  }

  @override
  Future<Either<AppException, dynamic>> googleSignIn(
      {required String accessToken}) async {
    try {
      final googleSignInResult = await networkService.patch(
        '/auth/user/login-with-google',
        headers: networkService.updateHeader(
          {
            'authorization': 'Google $accessToken',
          },
        ),
      );
      return googleSignInResult.fold(
        (exception) {
          return Left(exception);
        },
        (response) {
          if (response.data is String || response.data is bool) {
            return Right(bool.tryParse(response.data) ?? false);
          }
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
          identifier:
              '${exception.toString()}AuthRemoteDataSource.googleSignIn',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, AuthorizationResponse>> googleSignUp(
      {required String accessToken, required String username}) async {
    try {
      final googleSignUpResult =
          await networkService.post('/auth/user/register-with-google',
              headers: networkService.updateHeader(
                {
                  'authorization': 'Google $accessToken',
                },
              ),
              data: {
            "name": username,
          });
      return googleSignUpResult.fold(
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
          identifier:
              '${exception.toString()}AuthRemoteDataSource.googleSignUp',
        ),
      );
    }
  }
}
