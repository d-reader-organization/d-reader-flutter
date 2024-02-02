import 'dart:io' show File;

class UserModel {
  final int id, referralsRemaining;
  final String email, avatar, name, role;
  final bool isEmailVerified, hasBetaAccess;
  final List<String> deviceTokens;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.role,
    required this.isEmailVerified,
    required this.hasBetaAccess,
    required this.referralsRemaining,
    required this.deviceTokens,
  });

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      avatar: json['avatar'],
      name: json['name'],
      role: json['role'],
      isEmailVerified: json['isEmailVerified'],
      hasBetaAccess: json['hasBetaAccess'] ?? false,
      referralsRemaining: json['referralsRemaining'] ?? 0,
      deviceTokens: json['deviceTokens'] != null
          ? List<String>.from(json['deviceTokens'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['avatar'] = avatar;
    data['role'] = role;
    data['isEmailVerified'] = isEmailVerified;
    data['hasBetaAccess'] = hasBetaAccess;
    data['referralsRemaining'] = referralsRemaining;
    data['deviceTokens'] = deviceTokens;
    return data;
  }
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

class UpdateUserPayload {
  final int id;

  final File? avatar;
  final String? email, name, referrer;

  UpdateUserPayload({
    required this.id,
    this.email,
    this.name,
    this.avatar,
    this.referrer,
  });
}

  // Role
  // User: 'User',
  // Tester: 'Tester',
  // Admin: 'Admin',
  // Superadmin: 'Superadmin',