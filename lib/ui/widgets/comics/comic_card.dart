import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/comic_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/episode_circle.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:flutter/material.dart';

class ComicCard extends StatelessWidget {
  final ComicModel comic;
  const ComicCard({
    Key? key,
    required this.comic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        nextScreenPush(context, ComicDetails(slug: comic.slug));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: CachedImageBgPlaceholder(
          imageUrl: comic.cover,
          cacheKey: 'home${comic.cover}',
          height: 255,
          width: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EpisodeCircle(text: '${comic.stats?.issuesCount} EPs'),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        comic.name,
                        softWrap: true,
                        style: textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AuthorVerified(authorName: comic.creator.name),
                      FavouriteIconCount(favouritesCount: 49),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
