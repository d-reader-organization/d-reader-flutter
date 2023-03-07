import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/comic_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/episode_circle.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicCard extends ConsumerWidget {
  final ComicModel comic;
  const ComicCard({
    Key? key,
    required this.comic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        nextScreenPush(context, ComicDetails(slug: comic.slug));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 155,
        height: 255,
        child: Stack(
          children: [
            CachedImageBgPlaceholder(
              imageUrl: comic.cover,
              cacheKey: 'home${comic.slug}',
              foregroundDecoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    ColorPalette.boxBackground200,
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.0, 0.32],
                ),
                borderRadius: BorderRadius.circular(
                  16,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EpisodeCircle(text: '${comic.stats?.issuesCount} EPs'),
                      FavouriteIconCount(
                        favouritesCount: comic.stats?.favouritesCount ?? 0,
                        isFavourite: comic.myStats?.isFavourite ?? false,
                        slug: comic.slug,
                        variant: Variant.filled,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comic.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: textTheme.titleSmall,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      AuthorVerified(
                        authorName: comic.creator.name,
                        isVerified: comic.creator.isVerified,
                        textColor: const Color(0xFFb9b9b9),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
