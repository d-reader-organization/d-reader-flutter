class CreatorModel {
  final int? id;
  final String slug;
  final String name;
  final String avatar;
  final String banner;
  final String description;
  final bool isVerified;
  final CreatorStats? stats;
  final CreatorMyStats? myStats;

  CreatorModel({
    this.id,
    required this.slug,
    required this.name,
    required this.avatar,
    required this.banner,
    required this.description,
    required this.isVerified,
    this.stats,
    this.myStats,
  });

  factory CreatorModel.fromJson(dynamic json) {
    return CreatorModel(
      id: json['id'],
      slug: json['slug'],
      name: json['name'],
      avatar: json['avatar'],
      banner: json['banner'] ?? '',
      description: json['description'] ?? '',
      isVerified: json['isVerified'],
      stats:
          json['stats'] != null ? CreatorStats.fromJson(json['stats']) : null,
      myStats: json['myStats'] != null
          ? CreatorMyStats.fromJson(json['myStats'])
          : null,
    );
  }
}

class CreatorStats {
  final int comicIssuesCount;
  final double totalVolume;

  CreatorStats({
    required this.comicIssuesCount,
    required this.totalVolume,
  });

  factory CreatorStats.fromJson(dynamic json) => CreatorStats(
        comicIssuesCount: json['comicIssuesCount'],
        totalVolume: double.tryParse(json['totalVolume'].toStringAsFixed(2))
                ?.toDouble() ??
            0,
      );
}

class CreatorMyStats {
  final bool? isFollowing;

  CreatorMyStats({this.isFollowing});

  factory CreatorMyStats.fromJson(dynamic json) => CreatorMyStats(
        isFollowing: json['isFollowing'],
      );
}
