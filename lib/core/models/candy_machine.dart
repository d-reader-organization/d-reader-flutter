class CandyMachineModel {
  String address;
  int supply, itemsMinted;
  int baseMintPrice;
  String? endsAt;

  CandyMachineModel({
    required this.address,
    required this.supply,
    required this.itemsMinted,
    required this.baseMintPrice,
    this.endsAt,
  });

  factory CandyMachineModel.fromJson(json) {
    return CandyMachineModel(
      address: json['address'],
      supply: json['supply'],
      itemsMinted: json['itemsMinted'],
      baseMintPrice: json['baseMintPrice'],
      endsAt: json['endsAt'],
    );
  }
}
