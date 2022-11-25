import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/episode_circle.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/viewed_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags.dart';
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
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: CachedImageBgPlaceholder(
              imageUrl: comic.cover,
              cacheKey: 'discover-${comic.cover}',
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EpisodeCircle(
                    text:
                        '${comic.stats?.issuesCount} EPs ${comic.isCompleted ? 'ENDED' : ''}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comic.name,
                      style: textTheme.titleSmall?.copyWith(
                        color: ColorPalette.dReaderYellow100,
                      ),
                    ),
                    AuthorVerified(authorName: comic.creator.name),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingIcon(rating: comic.stats?.averageRating ?? 0),
                        FavouriteIconCount(
                          favouritesCount: comic.stats?.favouritesCount ?? 0,
                          isFavourite: comic.myStats?.isFavourite ?? false,
                          slug: comic.slug,
                        ),
                        ViewedIconCount(
                          viewedCount: comic.stats?.viewersCount ?? 0,
                        ),
                      ],
                    ),
                    const Divider(
                      height: 2,
                      color: ColorPalette.boxBackground300,
                    ),
                  ],
                ),
                GenreTags(
                  genres: comic.genres,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
