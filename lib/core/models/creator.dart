import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';

class CreatorModel {
  final int id;
  final String email;
  final String slug;
  final String name;
  final String avatar;
  final String banner;
  final String description;
  final List<ComicModel> comics;
  final List<ComicIssueModel> issues;
  final CreatorStats stats;

  CreatorModel({
    required this.id,
    required this.email,
    required this.slug,
    required this.name,
    required this.avatar,
    required this.banner,
    required this.description,
    required this.comics,
    required this.issues,
    required this.stats,
  });

  factory CreatorModel.fromJson(dynamic json) {
    return CreatorModel(
      id: json['id'],
      email: json['email'],
      slug: json['slug'],
      name: json['name'],
      avatar: json['avatar'],
      banner: json['banner'],
      description: json['description'],
      comics: json['comics'] != null
          ? List.from(
              json['comics'].map(
                (item) => ComicModel.fromJson(
                  item,
                ),
              ),
            )
          : [],
      issues: json['issues'] != null
          ? List.from(
              json['issues'].map(
                (item) => ComicIssueModel.fromJson(
                  item,
                ),
              ),
            )
          : [],
      stats: CreatorStats.fromJson(json['stats']),
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
        totalVolume: double.tryParse(json['totalVolume'].toString()) ?? 0,
      );
}
