import 'package:http/http.dart' show MultipartFile;

class WalletModel {
  final String role;
  final String address;
  final String name;
  final String avatar;
  final bool hasBetaAccess;

  WalletModel({
    required this.role,
    required this.address,
    required this.name,
    required this.avatar,
    required this.hasBetaAccess,
  });

  factory WalletModel.fromJson(dynamic json) {
    return WalletModel(
      role: json['role'],
      address: json['address'],
      name: json['name'],
      avatar: json['avatar'],
      hasBetaAccess: json['hasBetaAccess'],
    );
  }
}

class UpdateWalletPayload {
  final String address;
  final MultipartFile? avatar;
  final String? name;

  UpdateWalletPayload({
    required this.address,
    this.avatar,
    this.name,
  });
}
