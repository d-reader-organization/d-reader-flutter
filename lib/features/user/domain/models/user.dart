import 'dart:io' show File;

class UserModel {
  final int id, referralsRemaining;
  final String avatar, displayName, email, role, username;
  final bool isEmailVerified, hasBetaAccess;
  final List<String> deviceTokens;

  UserModel({
    required this.id,
    required this.avatar,
    required this.displayName,
    required this.email,
    required this.role,
    required this.username,
    required this.isEmailVerified,
    required this.hasBetaAccess,
    required this.referralsRemaining,
    required this.deviceTokens,
  });

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      id: json['id'],
      avatar: json['avatar'],
      displayName: json['displayName'] ?? '',
      email: json['email'],
      role: json['role'],
      username: json['username'] ?? json['name'],
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
    data['avatar'] = avatar;
    data['displayName'] = displayName;
    data['email'] = email;
    data['role'] = role;
    data['username'] = username;
    data['isEmailVerified'] = isEmailVerified;
    data['hasBetaAccess'] = hasBetaAccess;
    data['referralsRemaining'] = referralsRemaining;
    data['deviceTokens'] = deviceTokens;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      other is UserModel && other.runtimeType == runtimeType && other.id == id;

  @override
  int get hashCode => Object.hash(runtimeType, id, email);
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
  final String? displayName, email, referrer, username;

  UpdateUserPayload({
    required this.id,
    this.displayName,
    this.email,
    this.username,
    this.avatar,
    this.referrer,
  });
}
