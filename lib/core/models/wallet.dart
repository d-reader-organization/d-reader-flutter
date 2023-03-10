import 'package:http/http.dart' show MultipartFile;

class WalletModel {
  final String role;
  final String address;
  final String label;
  final String avatar;

  WalletModel({
    required this.role,
    required this.address,
    required this.label,
    required this.avatar,
  });

  factory WalletModel.fromJson(dynamic json) {
    return WalletModel(
      role: json['role'],
      address: json['address'],
      label: json['label'],
      avatar: json['avatar'],
    );
  }
}

class UpdateWalletPayload {
  final String address;
  final MultipartFile? avatar;
  final String? label;

  UpdateWalletPayload({
    required this.address,
    this.avatar,
    this.label,
  });
}
