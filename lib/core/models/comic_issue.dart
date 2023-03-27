import 'package:d_reader_flutter/core/models/creator.dart';

class ComicIssueModel {
  final int id;
  final int number;
  final String title;
  final String slug;
  final String description;
  final String cover;
  final ComicIssueStats? stats;
  final ComicIssueMyStats? myStats;
  final ComicType? comic;
  final CreatorModel creator;
  final bool isPopular, isFree;
  final DateTime releaseDate;
  final int supply;
  final String? candyMachineAddress;
  final double sellerFee;

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
    required this.isFree,
    required this.sellerFee,
    this.candyMachineAddress,
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
      isFree: json['isFree'],
      candyMachineAddress: json['candyMachineAddress'],
      sellerFee:
          json['sellerFee'] is int ? json['sellerFee'] + .0 : json['sellerFee'],
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
      totalPagesCount;
  final double totalVolume;
  final double? price, averageRating;

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

  factory ComicIssueStats.fromJson(dynamic json) => ComicIssueStats(
        price: double.tryParse(json['price'].toStringAsFixed(2))?.toDouble(),
        totalVolume: 122.4,
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

  factory ComicIssueMyStats.fromJson(dynamic json) => ComicIssueMyStats(
        rating: json['rating'],
        isFavourite: json['isFavourite'],
        canRead: json['canRead'],
        readAt: json['readAt'],
        viewedAt: json['viewedAt'] != null
            ? DateTime.parse(
                json['viewedAt'],
              )
            : null,
      );
}

class ComicType {
  final String name;
  final String slug;
  final String audienceType;

  ComicType({
    required this.name,
    required this.slug,
    required this.audienceType,
  });

  factory ComicType.fromJson(dynamic json) {
    return ComicType(
      name: json['name'],
      slug: json['slug'],
      audienceType: json['audienceType'],
    );
  }
}
