import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/models/wallet_asset.dart';

abstract class UserRepository {
  Future<UserModel?> myUser();
  Future<dynamic> updateAvatar(UpdateUserPayload payload);
  Future<dynamic> updateUser(UpdateUserPayload payload);
  Future<dynamic> updatePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  });
  Future<bool> validateName(String name);
  Future<bool> validateEmail(String email);
  Future<String> updateReferrer(String referrer);
  Future<dynamic> syncWallets(int id);
  Future<void> resetPassword(
    String id,
  );
  Future<dynamic> requestPasswordReset(String email);
  Future<void> requestEmailVerification();
  Future<void> requestChangeEmail(String newEmail);
  Future<List<WalletModel>> userWallets(int id);
  Future<List<WalletAsset>> userAssets(int id);
}
