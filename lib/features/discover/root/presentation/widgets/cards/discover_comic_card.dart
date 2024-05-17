import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/mature_audience.dart';
import 'package:d_reader_flutter/shared/widgets/icons/favorite_icon_count.dart';
import 'package:d_reader_flutter/shared/widgets/icons/rating_icon.dart';
import 'package:d_reader_flutter/features/discover/genre/presentation/widgets/genre_tags_default.dart';
import 'package:flutter/material.dart';

class DiscoverComicCard extends StatelessWidget {
  final ComicModel comic;
  const DiscoverComicCard({
    super.key,
    required this.comic,
  });

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
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: AspectRatio(
                aspectRatio: comicAspectRatio,
                child: LayoutBuilder(builder: (context, constraints) {
                  return CachedImageBgPlaceholder(
                    imageUrl: comic.cover,
                    borderRadius: 8,
                    opacity: .4,
                    cacheHeight: constraints.maxHeight.cacheSize(context),
                    cacheWidth: constraints.maxWidth.cacheSize(context),
                    child: comic.logo.isNotEmpty
                        ? CachedNetworkImage(
                            key: ValueKey(comic.logo),
                            imageUrl: comic.logo,
                            memCacheWidth:
                                constraints.maxWidth.cacheSize(context),
                            memCacheHeight:
                                (constraints.maxHeight / 2).cacheSize(context),
                          )
                        : null,
                  );
                }),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 5,
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
                          Expanded(
                            child: Text(
                              comic.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        comic.creator?.name ?? '',
                        style: textTheme.bodySmall?.copyWith(
                          color: ColorPalette.greyscale100,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${comic.stats?.issuesCount ?? 0} EPs',
                        style: textTheme.bodySmall,
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
                              FavoriteIconCount(
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
