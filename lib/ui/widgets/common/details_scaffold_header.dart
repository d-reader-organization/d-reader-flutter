import 'package:d_reader_flutter/core/models/details_scaffold_model.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/details_header_image.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/stats_info.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags_default.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailsScaffoldHeader<T> extends ConsumerWidget {
  final bool isComicDetails;
  final DetailsScaffoldModel detailsScaffoldModel;
  const DetailsScaffoldHeader({
    Key? key,
    required this.isComicDetails,
    required this.detailsScaffoldModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              GenreTagsDefault(genres: detailsScaffoldModel.genres ?? []),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => nextScreenPush(
                      context,
                      CreatorDetailsView(
                        slug: detailsScaffoldModel.creatorSlug,
                      ),
                    ),
                    child: Row(
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
                          authorName: detailsScaffoldModel.creatorName,
                          isVerified: detailsScaffoldModel.isVerifiedCreator,
                          fontSize: 15,
                        ),
                      ],
                    ),
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
                height: 24,
              ),
              // different for comic issues
              isComicDetails
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatsInfo(
                          title: 'VOLUME',
                          stats:
                              '${detailsScaffoldModel.generalStats.totalVolume}◎',
                        ),
                        StatsInfo(
                          title: 'ISSUES',
                          stats:
                              '${detailsScaffoldModel.generalStats.totalIssuesCount}',
                        ),
                        StatsInfo(
                          title: 'READERS',
                          stats:
                              '${detailsScaffoldModel.generalStats.readersCount}',
                        ),
                        StatsInfo(
                          title: detailsScaffoldModel.generalStats.isCompleted
                              ? 'COMPLETED'
                              : 'ONGOING',
                          stats: '',
                          statsWidget: const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.white,
                          ),
                          isLastItem: true,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StatsInfo(
                              title: 'VOLUME',
                              stats:
                                  '${detailsScaffoldModel.generalStats.totalVolume}◎',
                            ),
                            StatsInfo(
                              title: 'SUPPLY',
                              stats:
                                  '${detailsScaffoldModel.generalStats.totalSupply}',
                            ),
                            StatsInfo(
                              title: 'LISTED',
                              stats:
                                  '${detailsScaffoldModel.generalStats.totalListedCount}',
                            ),
                            StatsInfo(
                              title: 'FLOOR',
                              stats:
                                  '${detailsScaffoldModel.generalStats.floorPrice ?? '-.--'}◎',
                              isLastItem: true,
                            ),
                          ],
                        ),
                        // RoundedButton(
                        //   text: 'MINT',
                        //   size: const Size(double.infinity, 50),
                        //   onPressed: () async {
                        //     bool response =
                        //         await ref.read(solanaProvider.notifier).mint();
                        //     print('boolean: $response');
                        //   },
                        // ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
