import 'package:d_reader_flutter/features/authentication/data/datasource/auth_remote_source.dart';
import 'package:d_reader_flutter/features/authentication/domain/models/authorization_response.dart';
import 'package:d_reader_flutter/features/authentication/domain/repositories/auth_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl(this.authDataSource);

  @override
  Future<Either<AppException, AuthorizationResponse>> signIn({
    required String nameOrEmail,
    required String password,
  }) {
    return authDataSource.signIn(nameOrEmail: nameOrEmail, password: password);
  }

  @override
  Future<Either<AppException, AuthorizationResponse>> signUp({
    required String email,
    required String password,
    required String username,
  }) {
    return authDataSource.signUp(
        email: email, password: password, username: username);
  }

  @override
  Future<Either<AppException, bool>> validateUsername(String username) {
    return authDataSource.validateUsername(username);
  }

  @override
  Future<Either<AppException, bool>> requestEmailVerification() {
    return authDataSource.requestEmailVerification();
  }

  @override
  Future<void> connectWallet({
    required String address,
    required String encoding,
    required String apiUrl,
    required String jwtToken,
  }) {
    return authDataSource.connectWallet(
      address: address,
      encoding: encoding,
      apiUrl: apiUrl,
      jwtToken: jwtToken,
    );
  }

  @override
  Future<Either<AppException, String>> getOneTimePassword({
    required String address,
    required String apiUrl,
    required String jwtToken,
  }) {
    return authDataSource.getOneTimePassword(
      address: address,
      apiUrl: apiUrl,
      jwtToken: jwtToken,
    );
  }

  @override
  Future<void> disconnectWallet({required String address}) {
    return authDataSource.disconnectWallet(address);
  }

  @override
  Future<Either<AppException, String>> refreshToken(String refreshToken) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }
}
