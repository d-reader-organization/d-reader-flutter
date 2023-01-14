import 'package:d_reader_flutter/core/models/details_scaffold_model.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/details_header_image.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:d_reader_flutter/ui/widgets/creators/stats_box.dart';
import 'package:flutter/material.dart';

class DetailsScaffoldHeader<T> extends StatelessWidget {
  final bool isComicDetails;
  final DetailsScaffoldModel detailsScaffoldModel;
  const DetailsScaffoldHeader({
    Key? key,
    required this.isComicDetails,
    required this.detailsScaffoldModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailsHeaderImage(
          isComicDetails: isComicDetails,
          data: detailsScaffoldModel,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CreatorAvatar(
                        avatar: detailsScaffoldModel.avatarUrl,
                        radius: 24,
                        height: 32,
                        width: 32,
                        slug: detailsScaffoldModel.creatorSlug,
                      ),
                      const SizedBox(width: 12),
                      AuthorVerified(
                        authorName: detailsScaffoldModel.authorName,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      RatingIcon(
                        rating:
                            detailsScaffoldModel.generalStats.averageRating ??
                                0,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      FavouriteIconCount(
                        favouritesCount:
                            detailsScaffoldModel.favouriteStats.count,
                        isFavourite:
                            detailsScaffoldModel.favouriteStats.isFavourite,
                        slug: detailsScaffoldModel.slug,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              // different for comic issues
              isComicDetails
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatsBox(
                          title: 'TOTAL VOL',
                          stats:
                              '${detailsScaffoldModel.generalStats.totalVolume} ',
                          isSmall: true,
                        ),
                        StatsBox(
                          title: 'ISSUES',
                          stats:
                              '${detailsScaffoldModel.generalStats.totalIssuesCount}',
                          isSmall: true,
                        ),
                        StatsBox(
                          title: 'READERS',
                          stats:
                              '${detailsScaffoldModel.generalStats.readersCount}',
                          isSmall: true,
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatsBox(
                          title: 'VOL',
                          stats:
                              '${detailsScaffoldModel.generalStats.totalVolume} ',
                          isSmall: true,
                        ),
                        StatsBox(
                          title: 'SUPPLY',
                          stats:
                              '${detailsScaffoldModel.generalStats.totalSupply}',
                          isSmall: true,
                        ),
                        const StatsBox(
                          title: 'LISTED',
                          stats: '98',
                          isSmall: true,
                        ),
                        StatsBox(
                          title: 'FP',
                          stats:
                              '${detailsScaffoldModel.generalStats.floorPrice}',
                          isSmall: true,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
