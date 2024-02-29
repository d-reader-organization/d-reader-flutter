import 'package:d_reader_flutter/features/authentication/data/datasource/auth_remote_source.dart';
import 'package:d_reader_flutter/features/authentication/domain/models/authorization_response.dart';
import 'package:d_reader_flutter/features/authentication/domain/repositories/auth_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/app_exception.dart';

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
}
