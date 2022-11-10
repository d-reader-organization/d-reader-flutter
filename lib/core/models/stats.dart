class StatsModel {
  final int favouritesCount;

  StatsModel({
    required this.favouritesCount,
  });

  factory StatsModel.fromJson(dynamic json) {
    return StatsModel(
      favouritesCount: json['favouritesCount'] ?? 0,
    );
  }
}
