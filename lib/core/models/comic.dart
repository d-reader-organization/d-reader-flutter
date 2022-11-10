import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/models/stats.dart';

class ComicModel {
  final String name;
  final String slug;
  final String cover;
  final List<ComicIssueModel> issues;
  final CreatorModel creator;
  final StatsModel stats;

  ComicModel({
    required this.name,
    required this.slug,
    required this.cover,
    required this.issues,
    required this.creator,
    required this.stats,
  });

  factory ComicModel.fromJson(dynamic json) => ComicModel(
        name: json['name'],
        slug: json['slug'],
        cover: json['cover'],
        issues: json['issues'] ?? [],
        creator: json['creator'] ??
            CreatorModel(
                id: 1,
                email: 'creator@gmail.com',
                name: 'DefaultCreator',
                avatar: ''),
        stats: StatsModel.fromJson(json['stats']),
      );
}
