import 'package:d_reader_flutter/core/models/collaborator.dart';
import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/core/models/stateful_cover.dart';
import 'package:d_reader_flutter/core/models/stateless_cover.dart';

class ComicIssueModel {
  final int id, number, supply;
  final String cover, description, slug, title, comicSlug, creatorAddress;
  final bool isPopular, isFreeToRead, isFullyUploaded;
  final String? candyMachineAddress;
  final double sellerFee;
  final DateTime releaseDate;
  final ComicIssueStats? stats;
  final ComicIssueMyStats? myStats;
  final ComicType? comic;
  final CreatorModel creator;
  final List<Collaborator>? collaborators;
  final List<StatelessCover>? statelessCovers;
  final List<StatefulCover>? statefulCovers;
  final List<GenreModel> genres;

  ComicIssueModel({
    required this.id,
    required this.number,
    required this.title,
    required this.slug,
    required this.description,
    required this.cover,
    this.stats,
    this.myStats,
    required this.comic,
    required this.creator,
    required this.isPopular,
    required this.releaseDate,
    required this.supply,
    required this.isFreeToRead,
    required this.isFullyUploaded,
    required this.sellerFee,
    required this.genres,
    this.candyMachineAddress,
    this.collaborators,
    this.statelessCovers,
    this.statefulCovers,
    required this.comicSlug,
    required this.creatorAddress,
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
      myStats: json['myStats'] != null
          ? ComicIssueMyStats.fromJson(json['myStats'])
          : null,
      comic: json['comic'] != null ? ComicType.fromJson(json['comic']) : null,
      creator: CreatorModel.fromJson(json['creator']),
      isPopular: json['isPopular'],
      releaseDate: DateTime.parse(
        json['releaseDate'],
      ),
      supply: json['supply'],
      isFreeToRead: json['isFreeToRead'],
      isFullyUploaded: json['isFullyUploaded'],
      candyMachineAddress: json['candyMachineAddress'],
      sellerFee:
          json['sellerFee'] is int ? json['sellerFee'] + .0 : json['sellerFee'],
      collaborators: json['collaborators'] != null
          ? List<Collaborator>.from(
              json['collaborators'].map(
                (item) => Collaborator.fromJson(
                  item,
                ),
              ),
            )
          : [],
      statelessCovers: json['statelessCovers'] != null
          ? List<StatelessCover>.from(
              json['statelessCovers'].map(
                (item) => StatelessCover.fromJson(
                  item,
                ),
              ),
            )
          : [],
      statefulCovers: json['statefulCovers'] != null
          ? List<StatefulCover>.from(
              json['statefulCovers'].map(
                (item) => StatefulCover.fromJson(
                  item,
                ),
              ),
            )
          : [],
      genres: json['genres'] != null
          ? List<GenreModel>.from(
              json['genres'].map(
                (item) => GenreModel.fromJson(
                  item,
                ),
              ),
            )
          : [],
      comicSlug: json['comicSlug'],
      creatorAddress: json['creatorAddress'],
    );
  }
}

class ComicIssueStats {
  final int favouritesCount,
      ratersCount,
      totalIssuesCount,
      totalListedCount,
      readersCount,
      viewersCount,
      totalPagesCount,
      totalVolume;
  final int? price;
  final double? averageRating;

  ComicIssueStats({
    required this.favouritesCount,
    required this.ratersCount,
    required this.totalIssuesCount,
    required this.totalListedCount,
    required this.readersCount,
    required this.viewersCount,
    required this.totalPagesCount,
    required this.price,
    required this.totalVolume,
    this.averageRating,
  });

  factory ComicIssueStats.fromJson(dynamic json) {
    return ComicIssueStats(
      price: json['price'],
      totalVolume: 1220000000,
      averageRating: json['averageRating'] != null
          ? double.tryParse(json['averageRating'].toStringAsFixed(1))
              ?.toDouble()
          : null,
      totalIssuesCount: json['totalIssuesCount'],
      favouritesCount: json['favouritesCount'],
      // subscribersCount: json['subscribersCount'],
      totalListedCount: json['totalListedCount'] ?? 15,
      readersCount: json['readersCount'],
      viewersCount: json['viewersCount'],
      totalPagesCount: json['totalPagesCount'],
      ratersCount: json['ratersCount'] ?? 0,
    );
  }
}

class ComicIssueMyStats {
  final int? rating;
  final bool? isFavourite;
  final bool canRead;
  final DateTime? readAt, viewedAt;

  ComicIssueMyStats({
    this.rating,
    this.isFavourite,
    required this.canRead,
    this.readAt,
    this.viewedAt,
  });

  factory ComicIssueMyStats.fromJson(dynamic json) {
    return ComicIssueMyStats(
      rating: json['rating'],
      isFavourite: json['isFavourite'],
      canRead: json['canRead'],
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      viewedAt: json['viewedAt'] != null
          ? DateTime.parse(
              json['viewedAt'],
            )
          : null,
    );
  }
}

class ComicType {
  final String title;
  final String slug;
  final String audienceType;

  ComicType({
    required this.title,
    required this.slug,
    required this.audienceType,
  });

  factory ComicType.fromJson(dynamic json) {
    return ComicType(
      title: json['title'],
      slug: json['slug'],
      audienceType: json['audienceType'],
    );
  }
}
