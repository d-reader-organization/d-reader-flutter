class CollectionStatsModel {
  final int floorPrice, itemsListed, totalVolume, supply;

  CollectionStatsModel({
    required this.totalVolume,
    required this.itemsListed,
    required this.floorPrice,
    required this.supply,
  });

  factory CollectionStatsModel.fromJson(Map<String, dynamic> json) {
    return CollectionStatsModel(
      totalVolume: json['totalVolume'],
      itemsListed: json['itemsListed'],
      floorPrice: json['floorPrice'],
      supply: json['supply'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalVolume'] = totalVolume;
    data['itemsListed'] = itemsListed;
    data['floorPrice'] = floorPrice;
    data['supply'] = supply;
    return data;
  }
}
