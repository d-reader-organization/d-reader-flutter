class WalletGroupModel {
  final int itemsMinted;
  final int? supply;
  final bool isEligible;

  WalletGroupModel({
    required this.itemsMinted,
    this.supply,
    required this.isEligible,
  });

  factory WalletGroupModel.fromJson(dynamic json) {
    return WalletGroupModel(
      itemsMinted: json['itemsMinted'] ?? 0,
      supply: json['supply'],
      isEligible: json['isEligible'],
    );
  }
}
