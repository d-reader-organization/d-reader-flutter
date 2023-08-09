import 'package:d_reader_flutter/core/models/user.dart';

abstract class UserRepository {
  Future<UserModel?> myUser();
  Future<dynamic> updateAvatar(UpdateUserPayload payload);
  Future<dynamic> updateUser(UpdateUserPayload payload);
  Future<bool> validateName(String name);
  Future<bool> validateEmail(String email);
  Future<String> updateReferrer(String referrer);
  Future<dynamic> syncWallets(int id);
  Future<void> resetPassword({
    required String newPassword,
    required String id,
  });
  Future<void> requestEmailVerification();
  Future<void> verifyEmail({
    required String verificationToken,
  });
}
