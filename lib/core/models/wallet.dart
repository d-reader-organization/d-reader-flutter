class WalletModel {
  final String address;

  WalletModel({
    required this.address,
  });

  factory WalletModel.fromJson(dynamic json) {
    return WalletModel(
      address: json['address'],
    );
  }
}
