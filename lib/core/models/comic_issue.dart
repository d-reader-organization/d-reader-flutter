import 'package:d_reader_flutter/core/models/creator.dart';

class ComicIssueModel {
  final int id;
  final int number;
  final String title;
  final String slug;
  final String description;
  final String cover;
  final ComicIssueStats? stats;
  final ComicType? comic;
  final CreatorModel creator;
  final bool isPopular, isFree;
  final DateTime releaseDate;
  final int supply;

  ComicIssueModel({
    required this.id,
    required this.number,
    required this.title,
    required this.slug,
    required this.description,
    required this.cover,
    this.stats,
    required this.comic,
    required this.creator,
    required this.isPopular,
    required this.releaseDate,
    required this.supply,
    required this.isFree,
  });

  factory ComicIssueModel.fromJson(dynamic json) {
    return ComicIssueModel(
      id: json['id'],
      number: json['number'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      cover: json['cover'],
      stats: json['stats'] != null
          ? ComicIssueStats.fromJson(json['stats'])
          : null,
      comic: json['comic'] != null ? ComicType.fromJson(json['comic']) : null,
      creator: CreatorModel.fromJson(json['creator']),
      isPopular: json['isPopular'],
      releaseDate: DateTime.parse(
        json['releaseDate'],
      ),
      supply: json['supply'],
      isFree: json['isFree'],
    );
  }
}

class ComicIssueStats {
  final double floorPrice, totalVolume;
  final double? averageRating;
  final int totalIssuesCount,
      favouritesCount,
      totalListedCount,
      readersCount,
      viewersCount,
      totalPagesCount;

  ComicIssueStats({
    required this.floorPrice,
    required this.totalVolume,
    this.averageRating,
    required this.totalIssuesCount,
    required this.favouritesCount,
    required this.totalListedCount,
    required this.readersCount,
    required this.viewersCount,
    required this.totalPagesCount,
  });

  factory ComicIssueStats.fromJson(dynamic json) => ComicIssueStats(
        floorPrice: double.tryParse(json['floorPrice'].toStringAsFixed(2))
                ?.toDouble() ??
            0,
        totalVolume: double.tryParse(json['totalVolume'].toStringAsFixed(2))
                ?.toDouble() ??
            0,
        averageRating: json['averageRating'] != null
            ? double.tryParse(json['averageRating'].toStringAsFixed(2))
                ?.toDouble()
            : null,
        totalIssuesCount: json['totalIssuesCount'],
        favouritesCount: json['favouritesCount'],
        // subscribersCount: json['subscribersCount'],
        totalListedCount: json['totalListedCount'],
        readersCount: json['readersCount'],
        viewersCount: json['viewersCount'],
        totalPagesCount: json['totalPagesCount'],
      );
}

class ComicType {
  final String name;
  final String slug;
  final bool isMatureAudience;

  ComicType({
    required this.name,
    required this.slug,
    required this.isMatureAudience,
  });

  factory ComicType.fromJson(dynamic json) {
    return ComicType(
      name: json['name'],
      slug: json['slug'],
      isMatureAudience: json['isMatureAudience'],
    );
  }
}
