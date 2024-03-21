class CreatorModel {
  final int? id;
  final String avatar,
      banner,
      description,
      instagram,
      lynkfire,
      name,
      slug,
      twitter,
      website;
  final bool isVerified;
  final CreatorStats? stats;
  final CreatorMyStats? myStats;

  CreatorModel({
    this.id,
    required this.avatar,
    required this.banner,
    required this.description,
    required this.instagram,
    required this.isVerified,
    required this.lynkfire,
    required this.name,
    required this.slug,
    required this.twitter,
    required this.website,
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
      instagram: json['instagram'] ?? '',
      isVerified: json['isVerified'],
      lynkfire: json['lynkfire'] ?? '',
      twitter: json['twitter'] ?? '',
      website: json['website'] ?? '',
      stats:
          json['stats'] != null ? CreatorStats.fromJson(json['stats']) : null,
      myStats: json['myStats'] != null
          ? CreatorMyStats.fromJson(json['myStats'])
          : null,
    );
  }
}

class CreatorStats {
  final int comicIssuesCount, followersCount, totalVolume, comicsCount;

  CreatorStats({
    required this.comicIssuesCount,
    required this.followersCount,
    required this.totalVolume,
    required this.comicsCount,
  });

  factory CreatorStats.fromJson(dynamic json) {
    return CreatorStats(
      comicIssuesCount: json['comicIssuesCount'],
      followersCount: json['followersCount'],
      totalVolume: json['totalVolume'],
      comicsCount: json['comicsCount'] ?? 0,
    );
  }
}

class CreatorMyStats {
  final bool? isFollowing;

  CreatorMyStats({this.isFollowing});

  factory CreatorMyStats.fromJson(dynamic json) => CreatorMyStats(
        isFollowing: json['isFollowing'],
      );
}
