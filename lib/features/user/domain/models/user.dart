import 'dart:io' show File;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class UserModel with _$UserModel {
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

@freezed
class UpdateUserPayload with _$UpdateUserPayload {
  const factory UpdateUserPayload({
    required int id,
    String? email,
    String? name,
    String? referrer,
    File? avatar,
  }) = _UpdateUserPayload;
}

enum UserRole {
  user,
  tester,
  admin,
  superadmin,
}

extension UserRoleValue on UserRole {
  static const userRoles = {
    UserRole.user: 'User',
    UserRole.tester: 'Tester',
    UserRole.admin: 'Admin',
    UserRole.superadmin: 'Superadmin',
  };

  String get name => userRoles[this] ?? 'User';
}
