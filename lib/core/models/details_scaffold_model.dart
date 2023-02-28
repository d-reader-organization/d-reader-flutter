import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/core/models/page_model.dart';

class DetailsScaffoldModel {
  final String slug;
  final String imageUrl;
  final String avatarUrl;
  final String title;
  final String subtitle;
  final String description;
  final String creatorSlug;
  final String creatorName;
  final bool isVerifiedCreator;
  final FavouriteStats favouriteStats;
  final GeneralStats generalStats;
  final List<GenreModel>? genres;
  final String? flavorText;
  final int? episodeNumber;
  final DateTime? releaseDate;
  final List<PageModel>? issuePages;

  DetailsScaffoldModel({
    required this.slug,
    required this.imageUrl,
    required this.avatarUrl,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.creatorSlug,
    required this.creatorName,
    required this.isVerifiedCreator,
    required this.favouriteStats,
    required this.generalStats,
    this.genres,
    this.flavorText,
    this.episodeNumber,
    this.releaseDate,
    this.issuePages,
  });
}

class FavouriteStats {
  final int count;
  final bool isFavourite;

  FavouriteStats({
    required this.count,
    required this.isFavourite,
  });
}

class GeneralStats {
  final double totalVolume;
  final double? floorPrice, averageRating;
  final int? readersCount,
      totalSupply,
      totalIssuesCount,
      totalListedCount,
      totalPagesCount;
  final bool? isPopular;
  final bool isCompleted;

  GeneralStats({
    required this.totalVolume,
    this.floorPrice,
    this.averageRating,
    this.readersCount,
    this.totalSupply,
    this.totalIssuesCount,
    this.isPopular,
    this.isCompleted = false,
    this.totalListedCount,
    this.totalPagesCount,
  });
}
