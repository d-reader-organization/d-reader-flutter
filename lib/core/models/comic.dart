import 'package:d_reader_flutter/core/models/creator.dart';

class ComicModel {
  final String name;
  final String slug;
  final String cover;
  final String description;
  final CreatorModel? creator;
  final ComicStats? stats;
  final bool isPopular;
  final bool isCompleted;

  ComicModel({
    required this.name,
    required this.slug,
    required this.cover,
    required this.description,
    this.creator,
    this.stats,
    required this.isPopular,
    required this.isCompleted,
  });

  factory ComicModel.fromJson(dynamic json) {
    return ComicModel(
      name: json['name'],
      slug: json['slug'],
      cover: json['cover'],
      description: json['description'],
      creator: json['creator'] != null
          ? CreatorModel.fromJson(json['creator'])
          : null,
      stats: json['stats'] != null ? ComicStats.fromJson(json['stats']) : null,
      isPopular: json['isPopular'],
      isCompleted: json['isCompleted'],
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
      averageRating: json['averageRating'],
      issuesCount: json['issuesCount'],
      totalVolume: json['totalVolume'],
      readersCount: json['readersCount'],
      viewersCount: json['viewersCount'],
    );
  }
}
