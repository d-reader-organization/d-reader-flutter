import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/episode_circle.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags.dart';
import 'package:flutter/material.dart';

class DiscoverComicIssueCard extends StatelessWidget {
  final ComicIssueModel issue;
  const DiscoverComicIssueCard({
    Key? key,
    required this.issue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      height: 145,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: CachedImageBgPlaceholder(
              imageUrl: issue.cover,
              cacheKey: 'discover-${issue.cover}',
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EpisodeCircle(
                    text: 'EP ${issue.number}/${issue.stats?.totalIssuesCount}',
                  ),
                ],
              ),
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
                    Text(
                      issue.title,
                      style: textTheme.titleSmall?.copyWith(
                        color: ColorPalette.dReaderYellow100,
                      ),
                    ),
                    AuthorVerified(authorName: issue.creator?.name ?? ''),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        AuthorVerified(authorName: 'Studio NX'),
                        FavouriteIconCount(favouritesCount: 49),
                      ],
                    ),
                  ],
                ),
                GenreTags(
                  genres: [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
