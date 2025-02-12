class CreatorModel {
  final int id;
  final String avatar,
      banner,
      description,
      displayName,
      instagram,
      linktree,
      handle,
      twitter,
      website;
  final bool isVerified;
  final CreatorStats? stats;
  final CreatorMyStats? myStats;

  CreatorModel({
    required this.id,
    required this.avatar,
    required this.banner,
    required this.description,
    required this.displayName,
    required this.instagram,
    required this.isVerified,
    required this.linktree,
    required this.handle,
    required this.twitter,
    required this.website,
    this.stats,
    this.myStats,
  });

  factory CreatorModel.fromJson(dynamic json) {
    return CreatorModel(
      id: json['id'] ?? 0,
      handle: json['handle'] ?? '',
      avatar: json['avatar'] ?? '',
      banner: json['banner'] ?? '',
      description: json['description'] ?? '',
      displayName: json['displayName'] ?? '',
      instagram: json['instagram'] ?? '',
      isVerified: json['isVerified'],
      linktree: json['linktree'] ?? '',
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
      comicIssuesCount: json['comicIssuesCount'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      totalVolume: json['totalVolume'] ?? 0,
      comicsCount: json['comicsCount'] ?? 0,
    );
  }
}

class CreatorMyStats {
  final bool? isFollowing;

  CreatorMyStats({this.isFollowing});

  factory CreatorMyStats.fromJson(dynamic json) {
    return CreatorMyStats(
      isFollowing: json['isFollowing'],
    );
  }
}
