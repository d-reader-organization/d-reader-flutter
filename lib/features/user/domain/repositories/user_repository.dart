import 'package:d_reader_flutter/features/user/domain/models/user.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet_asset.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class UserRepository {
  Future<Either<AppException, UserModel>> getMe();
  Future<Either<AppException, UserModel>> updateAvatar(
      UpdateUserPayload payload);
  Future<Either<AppException, UserModel>> updateUser(UpdateUserPayload payload);
  Future<Either<AppException, bool>> updatePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  });
  Future<void> syncWallets(int id);
  Future<void> requestPasswordReset(String email);
  Future<void> requestEmailVerification();
  Future<Either<AppException, bool>> requestChangeEmail(String newEmail);
  Future<Either<AppException, List<WalletModel>>> getUserWallets(int id);
  Future<Either<AppException, List<WalletAsset>>> getUserAssets(int id);
  Future<void> insertFcmToken(String fcmToken);
}
