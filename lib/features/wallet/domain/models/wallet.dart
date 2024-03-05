class WalletModel {
  final String address, label;

  WalletModel({
    required this.address,
    required this.label,
  });

  factory WalletModel.fromJson(dynamic json) {
    return WalletModel(
      address: json['address'],
      label: json['label'],
    );
  }
}
