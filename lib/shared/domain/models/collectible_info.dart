class CollectibleInfoModel {
  final bool isSecondarySaleActive;
  final String? activeCandyMachineAddress;

  CollectibleInfoModel({
    required this.isSecondarySaleActive,
    this.activeCandyMachineAddress,
  });

  factory CollectibleInfoModel.fromJson(dynamic json) {
    print(json);
    return CollectibleInfoModel(
      isSecondarySaleActive: json['isSecondarySaleActive'],
      activeCandyMachineAddress: json['activeCandyMachineAddress'],
    );
  }
}
