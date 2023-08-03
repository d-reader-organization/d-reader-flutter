import 'package:d_reader_flutter/core/models/user.dart';

abstract class UserRepository {
  Future<List<dynamic>> getAssets(int id); //TODO change to use UserAsset model
  Future<UserModel?> myUser();
  Future<dynamic> updateAvatar(UpdateUserPayload payload);
  Future<dynamic> updateUser(UpdateUserPayload payload);
  Future<bool> validateName(String name);
  Future<bool> validateEmail(String email);
  Future<String> updateReferrer(String referrer);
  Future<dynamic> syncWallets(int id);
}
