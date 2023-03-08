import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/models/genre.dart';

class ComicModel {
  final String name;
  final String slug;
  final String cover;
  final String description;
  final String flavorText;
  final CreatorModel creator;
  final ComicStats? stats;
  final bool isPopular;
  final bool isCompleted;
  final List<GenreModel> genres;
  final MyStats? myStats;
  final bool isMatureAudience;
  final bool isVerified;

  ComicModel({
    required this.name,
    required this.slug,
    required this.cover,
    required this.description,
    required this.flavorText,
    required this.creator,
    this.stats,
    required this.isPopular,
    required this.isCompleted,
    required this.genres,
    this.myStats,
    required this.isMatureAudience,
    required this.isVerified,
  });

  factory ComicModel.fromJson(dynamic json) {
    return ComicModel(
      name: json['name'],
      slug: json['slug'],
      cover: json['cover'],
      description: json['description'],
      flavorText: json['flavorText'],
      creator: CreatorModel.fromJson(json['creator']),
      stats: json['stats'] != null ? ComicStats.fromJson(json['stats']) : null,
      myStats:
          json['myStats'] != null ? MyStats.fromJson(json['myStats']) : null,
      isPopular: json['isPopular'],
      isCompleted: json['isCompleted'],
      genres: json['genres'] != null
          ? List<GenreModel>.from(
              json['genres'].map(
                (item) => GenreModel.fromJson(
                  item,
                ),
              ),
            )
          : [],
      isMatureAudience: json['isMatureAudience'],
      isVerified: json['isVerified'],
    );
  }
}

class ComicStats {
  final int favouritesCount;
  final int subscribersCount;
  final int ratersCount;
  final double averageRating;
  final int issuesCount;
  final double totalVolume;
  final int readersCount;
  final int viewersCount;

  ComicStats({
    required this.favouritesCount,
    required this.subscribersCount,
    required this.ratersCount,
    required this.averageRating,
    required this.issuesCount,
    required this.totalVolume,
    required this.readersCount,
    required this.viewersCount,
  });

  factory ComicStats.fromJson(dynamic json) {
    return ComicStats(
      favouritesCount: json['favouritesCount'],
      subscribersCount: json['subscribersCount'],
      ratersCount: json['ratersCount'],
      averageRating: json['averageRating'] != null
          ? double.tryParse(json['averageRating'].toStringAsFixed(2))
                  ?.toDouble() ??
              0
          : 0,
      issuesCount: json['issuesCount'],
      totalVolume:
          double.tryParse(json['totalVolume'].toStringAsFixed(2))?.toDouble() ??
              0,
      readersCount: json['readersCount'],
      viewersCount: json['viewersCount'],
    );
  }
}

class MyStats {
  final bool? isFavourite, isSubscribed;
  final double? rating;
  final DateTime? viewedAt;

  MyStats({
    this.isFavourite,
    this.isSubscribed,
    this.rating,
    this.viewedAt,
  });

  factory MyStats.fromJson(dynamic json) {
    return MyStats(
      isFavourite: json['isFavourite'],
      isSubscribed: json['isSubscribed'],
      rating: json['rating'],
      viewedAt:
          json['viewedAt'] != null ? DateTime.parse(json['viewedAt']) : null,
    );
  }
}
