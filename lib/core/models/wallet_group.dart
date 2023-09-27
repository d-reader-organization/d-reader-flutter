class WalletGroupModel {
  final int itemsMinted, itemsRemaining;
  final bool isEligible;

  WalletGroupModel({
    required this.itemsMinted,
    required this.itemsRemaining,
    required this.isEligible,
  });

  factory WalletGroupModel.fromJson(dynamic json) {
    return WalletGroupModel(
      itemsMinted: json['itemsMinted'],
      itemsRemaining: json['itemsRemaining'] ?? 0,
      isEligible: json['isEligible'],
    );
  }
}
