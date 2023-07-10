import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/comic_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
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
        nextScreenPush(context, ComicDetails(slug: comic.slug));
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                            style: textTheme.titleSmall,
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
                      AuthorVerified(
                        authorName: comic.creator.name,
                        isVerified: comic.creator.isVerified,
                        textColor: ColorPalette.greyscale100,
                        fontSize: 12,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${comic.stats?.issuesCount ?? 0} EPs',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        color: ColorPalette.boxBackground300,
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
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
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
