class UserGroupModel {
  final bool isEligible;
  final int? itemsMinted, supply;

  UserGroupModel({
    required this.isEligible,
    this.itemsMinted,
    this.supply,
  });

  factory UserGroupModel.fromJson(dynamic json) {
    return UserGroupModel(
      isEligible: json['isEligible'],
      itemsMinted: json['itemsMinted'],
      supply: json['supply'],
    );
  }
}
