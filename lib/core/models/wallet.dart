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
