import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/creator.dart';

class ComicModel {
  final String name;
  final String slug;
  final String cover;
  final String description;
  final List<ComicIssueModel> issues;
  final CreatorModel creator;
  final ComicStats? stats;
  final bool isPopular;

  ComicModel({
    required this.name,
    required this.slug,
    required this.cover,
    required this.description,
    required this.issues,
    required this.creator,
    required this.stats,
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
              stats: CreatorStats(comicIssuesCount: 5, totalVolume: 20),
            ),
        stats:
            json['stats'] != null ? ComicStats.fromJson(json['stats']) : null,
        isPopular: json['isPopular'],
      );
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

  factory ComicStats.fromJson(dynamic json) => ComicStats(
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