import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/creator.dart';

class ComicModel {
  final String name;
  final String slug;
  final String cover;
  final String description;
  final List<ComicIssueModel> issues;
  final CreatorModel creator;
  // final StatsModel stats;
  final bool isPopular;

  ComicModel({
    required this.name,
    required this.slug,
    required this.cover,
    required this.description,
    required this.issues,
    required this.creator,
    // required this.stats,
    required this.isPopular,
  });

  factory ComicModel.fromJson(dynamic json) => ComicModel(
        name: json['name'],
        slug: json['slug'],
        cover: json['cover'],
        description: json['description'],
        issues: json['issues'] ?? [],
        creator: json['creator'] ??
            CreatorModel(
              id: 1,
              email: 'creator@gmail.com',
              slug: 'creator',
              name: 'DefaultCreator',
              avatar: '',
              banner: '',
              description: 'Desc',
              comics: [],
              issues: [],
            ),
        // stats: StatsModel.fromJson(json['stats']),
        isPopular: json['isPopular'],
      );
}
