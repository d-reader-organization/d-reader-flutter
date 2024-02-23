import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/mature_audience.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags_default.dart';
import 'package:flutter/material.dart';

class DiscoverComicCard extends StatelessWidget {
  final ComicModel comic;
  const DiscoverComicCard({
    Key? key,
    required this.comic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.comicDetails}/${comic.slug}',
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: CachedImageBgPlaceholder(
                imageUrl: comic.cover,
                borderRadius: 8,
                height: 135,
                opacity: .4,
                child: comic.logo.isNotEmpty
                    ? CachedNetworkImage(
                        key: ValueKey(comic.logo),
                        imageUrl: comic.logo,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            comic.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium,
                          ),
                          // SvgPicture.asset(
                          //   comic.logo.isNotEmpty
                          //       ? 'assets/icons/bookmark_unsaved.svg'
                          //       : 'assets/icons/bookmark_saved.svg',
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        comic.creator?.name ?? '',
                        style: textTheme.titleSmall?.copyWith(
                          color: ColorPalette.greyscale100,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${comic.stats?.issuesCount ?? 0} EPs',
                        style: textTheme.titleSmall,
                      ),
                      const Divider(
                        thickness: 1,
                        color: ColorPalette.greyscale400,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              RatingIcon(
                                initialRating: comic.stats?.averageRating ?? 0,
                                isRatedByMe: true,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              FavouriteIconCount(
                                favouritesCount:
                                    comic.stats?.favouritesCount ?? 0,
                                isFavourite: true,
                              ),
                            ],
                          ),
                          MatureAudience(audienceType: comic.audienceType),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: DiscoverGenreTagsDefault(
                      genres: comic.genres,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
