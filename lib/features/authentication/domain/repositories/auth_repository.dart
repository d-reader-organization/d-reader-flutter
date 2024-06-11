import 'package:d_reader_flutter/features/authentication/domain/models/authorization_response.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class AuthRepository {
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
  Future<Either<AppException, String>> getOneTimePassword({
    required String address,
  });
  Future<void> connectWallet({
    required String address,
    required String encoding,
  });
  Future<void> disconnectWallet({
    required String address,
  });
  Future<String> refreshToken(String refreshToken);
  Future<Either<AppException, dynamic>> googleSignIn({
    required String accessToken,
  });
  Future<Either<AppException, AuthorizationResponse>> googleSignUp({
    required String accessToken,
    required String username,
  });
}
