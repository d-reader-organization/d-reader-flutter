// ignore_for_file: constant_identifier_names

import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/models/genre.dart';

enum AudienceType {
  Everyone,
  Teen,
  TeenPlus,
  Mature,
}

class ComicModel {
  final String title, slug, cover, banner, description, flavorText, logo;

  final CreatorModel? creator;
  final ComicStats? stats;
  final bool isPopular;
  final bool isCompleted;
  final List<GenreModel> genres;
  final MyStats? myStats;
  final String audienceType;
  final bool isVerified;

  ComicModel({
    required this.title,
    required this.slug,
    required this.cover,
    required this.banner,
    required this.description,
    required this.flavorText,
    this.creator,
    required this.logo,
    this.stats,
    required this.isPopular,
    required this.isCompleted,
    required this.genres,
    this.myStats,
    required this.audienceType,
    required this.isVerified,
  });

  factory ComicModel.fromJson(dynamic json) {
    return ComicModel(
      title: json['title'],
      slug: json['slug'],
      cover: json['cover'],
      banner: json['banner'],
      description: json['description'],
      flavorText: json['flavorText'],
      logo: json['logo'],
      creator: json['creator'] != null
          ? CreatorModel.fromJson(json['creator'])
          : null,
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
      isVerified: json['isVerified'],
      audienceType: json['audienceType'],
    );
  }
}

class ComicStats {
  final int favouritesCount,
      issuesCount,
      ratersCount,
      readersCount,
      totalVolume,
      viewersCount;

  final double averageRating;

  ComicStats({
    required this.favouritesCount,
    required this.ratersCount,
    required this.averageRating,
    required this.issuesCount,
    required this.totalVolume,
    required this.readersCount,
    required this.viewersCount,
  });

  factory ComicStats.fromJson(dynamic json) {
    return ComicStats(
      favouritesCount: json['favouritesCount'] ?? 0,
      ratersCount: json['ratersCount'] ?? 0,
      averageRating: json['averageRating'] != null
          ? double.tryParse(json['averageRating'].toStringAsFixed(1))
                  ?.toDouble() ??
              0
          : 0,
      issuesCount: json['issuesCount'] ?? 0,
      totalVolume: 1000000000,
      readersCount: json['readersCount'] ?? 0,
      viewersCount: json['viewersCount'] ?? 0,
    );
  }
}

class MyStats {
  final bool isFavourite, isSubscribed, isBookmarked;
  final int? rating;
  final DateTime? viewedAt;

  MyStats({
    required this.isFavourite,
    required this.isSubscribed,
    required this.isBookmarked,
    this.rating,
    this.viewedAt,
  });

  factory MyStats.fromJson(dynamic json) {
    return MyStats(
      isFavourite: json['isFavourite'] ?? false,
      isSubscribed: json['isSubscribed'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
      rating: json['rating'],
      viewedAt:
          json['viewedAt'] != null ? DateTime.parse(json['viewedAt']) : null,
    );
  }
}
