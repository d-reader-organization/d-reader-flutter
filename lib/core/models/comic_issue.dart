import 'package:d_reader_flutter/core/models/comic.dart';

class ComicIssueModel {
  final int id;
  final int number;
  final String title;
  final String slug;
  final String description;
  final String cover;
  final ComicIssueStats stats;
  final ComicModel? comic;

  ComicIssueModel({
    required this.id,
    required this.number,
    required this.title,
    required this.slug,
    required this.description,
    required this.cover,
    required this.stats,
    required this.comic,
  });

  factory ComicIssueModel.fromJson(dynamic json) {
    return ComicIssueModel(
      id: json['id'],
      number: json['number'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      cover: json['cover'],
      stats: ComicIssueStats.fromJson(json['stats']),
      comic: json['comic'],
    );
  }
}

class ComicIssueStats {
  final double floorPrice;
  final int totalSupply;
  final double totalVolume;

  ComicIssueStats({
    required this.floorPrice,
    required this.totalSupply,
    required this.totalVolume,
  });

  factory ComicIssueStats.fromJson(dynamic json) => ComicIssueStats(
        floorPrice: json['floorPrice'],
        totalSupply: json['totalSupply'],
        totalVolume: double.tryParse(json['totalVolume'].toString()) ?? 0,
      );
}
