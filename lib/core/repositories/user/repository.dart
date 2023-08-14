import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';

abstract class UserRepository {
  Future<UserModel?> myUser();
  Future<dynamic> updateAvatar(UpdateUserPayload payload);
  Future<dynamic> updateUser(UpdateUserPayload payload);
  Future<bool> validateName(String name);
  Future<bool> validateEmail(String email);
  Future<String> updateReferrer(String referrer);
  Future<dynamic> syncWallets(int id);
  Future<void> resetPassword(
    String id,
  );
  Future<void> requestEmailVerification();
  Future<List<WalletModel>> userWallets(int id);
}
