import 'package:d_reader_flutter/features/user/data/datasource/user_remote_data_source.dart';
import 'package:d_reader_flutter/features/user/domain/models/user.dart';
import 'package:d_reader_flutter/features/user/domain/repositories/user_repository.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet_asset.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Future<void> insertFcmToken(String fcmToken) {
    return dataSource.insertFcmToken(fcmToken);
  }

  @override
  Future<Either<AppException, UserModel>> getMe() {
    return dataSource.getMe();
  }

  @override
  Future<Either<AppException, bool>> requestChangeEmail(String newEmail) {
    return dataSource.requestChangeEmail(newEmail);
  }

  @override
  Future<Either<AppException, bool>> requestEmailVerification() {
    return dataSource.requestEmailVerification();
  }

  @override
  Future<Either<AppException, bool>> requestPasswordReset(String email) {
    return dataSource.requestPasswordReset(email);
  }

  @override
  Future<void> syncWallets(int id) {
    return dataSource.syncWallets(id);
  }

  @override
  Future<Either<AppException, UserModel>> updateAvatar(
      UpdateUserPayload payload) {
    return dataSource.updateAvatar(payload);
  }

  @override
  Future<Either<AppException, bool>> updatePassword(
      {required int userId,
      required String oldPassword,
      required String newPassword}) {
    return dataSource.updatePassword(
        userId: userId, oldPassword: oldPassword, newPassword: newPassword);
  }

  @override
  Future<Either<AppException, UserModel>> updateUser(
      UpdateUserPayload payload) {
    return dataSource.updateUser(payload);
  }

  @override
  Future<Either<AppException, List<WalletAsset>>> getUserAssets(int id) {
    return dataSource.getUserAssets(id);
  }

  @override
  Future<Either<AppException, List<WalletModel>>> getUserWallets(int id) {
    return dataSource.getUserWallets(id);
  }
}
