import 'package:d_reader_flutter/core/models/creator.dart';

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

class ComicIssueModel {
  final int id;
  final int number;
  final String title;
  final String slug;
  final String description;
  final String cover;
  final ComicIssueStats? stats;
  final ComicType? comic;
  final CreatorModel? creator;

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
      comic: ComicType.fromJson(json['comic']),
      creator: CreatorModel.fromJson(json['creator']),
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
