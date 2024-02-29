import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required int referralsRemaining,
    required String email,
    required String avatar,
    required String name,
    required String role,
    required bool isEmailVerified,
    required bool hasBetaAccess,
    required List<String> deviceTokens,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);
}
