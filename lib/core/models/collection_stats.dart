class CollectionStatsModel {
  final int totalVolume;
  final int itemsListed;
  final double floorPrice;

  CollectionStatsModel({
    required this.totalVolume,
    required this.itemsListed,
    required this.floorPrice,
  });

  factory CollectionStatsModel.fromJson(Map<String, dynamic> json) {
    return CollectionStatsModel(
      totalVolume: json['totalVolume'],
      itemsListed: json['itemsListed'],
      floorPrice: json['floorPrice'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalVolume'] = totalVolume;
    data['itemsListed'] = itemsListed;
    data['floorPrice'] = floorPrice;
    return data;
  }
}
