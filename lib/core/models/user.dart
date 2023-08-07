import 'dart:io' show File;

class UserModel {
  final int id;
  final String email, avatar, name, role;
  final bool isEmailVerified;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.role,
    required this.isEmailVerified,
  });

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      avatar: json['avatar'],
      name: json['name'],
      role: json['role'],
      isEmailVerified: json['isEmailVerified'],
    );
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