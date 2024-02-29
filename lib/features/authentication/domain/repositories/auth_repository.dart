import 'package:d_reader_flutter/features/authentication/domain/models/authorization_response.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/app_exception.dart';

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
}
