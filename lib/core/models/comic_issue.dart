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
  final bool isPopular;
  final DateTime releaseDate;

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
    );
  }
}

class ComicIssueStats {
  final double floorPrice;
  final int totalSupply;
  final double totalVolume;
  final int totalIssuesCount;

  ComicIssueStats({
    required this.floorPrice,
    required this.totalSupply,
    required this.totalVolume,
    required this.totalIssuesCount,
  });

  factory ComicIssueStats.fromJson(dynamic json) => ComicIssueStats(
        floorPrice: double.tryParse(json['floorPrice'].toStringAsFixed(2))
                ?.toDouble() ??
            0,
        totalSupply: json['totalSupply'],
        totalVolume: double.tryParse(json['totalVolume'].toStringAsFixed(2))
                ?.toDouble() ??
            0,
        totalIssuesCount: json['totalIssuesCount'],
      );
}

class ComicType {
  final String name;
  final String slug;

  ComicType({
    required this.name,
    required this.slug,
  });

  factory ComicType.fromJson(dynamic json) {
    return ComicType(
      name: json['name'],
      slug: json['slug'],
    );
  }
}
