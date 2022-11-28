import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/episode_circle.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/mature_audience.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/hot_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/viewed_icon_count.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: CachedImageBgPlaceholder(
              imageUrl: issue.cover,
              height: 145,
              cacheKey: 'discover-${issue.slug}',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EpisodeCircle(
                    text: 'EP ${issue.number}/${issue.stats?.totalIssuesCount}',
                  ),
                  issue.isPopular ? const HotIconSmall() : const SizedBox()
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.comic?.name ?? '',
                  style: textTheme.bodyMedium?.copyWith(
                    color: ColorPalette.dReaderYellow100,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  issue.title,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                AuthorVerified(authorName: issue.creator.name),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '${issue.releaseDate.day}-${issue.releaseDate.month}-${issue.releaseDate.year}',
                    style: textTheme.labelSmall,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                const Divider(
                  color: ColorPalette.boxBackground300,
                  height: 2,
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'FLOOR',
                          style: textTheme.labelSmall,
                        ),
                        Text(
                          issue.stats?.floorPrice.toString() ?? '',
                          style: textTheme.labelSmall?.copyWith(
                            color: ColorPalette.dReaderYellow100,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'TOTAL VOL',
                          style: textTheme.labelSmall,
                        ),
                        Text(
                          issue.stats?.totalVolume.toString() ?? '',
                          style: textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const ViewedIconCount(viewedCount: 1234),
                    issue.comic?.isMatureAudience != null &&
                            issue.comic!.isMatureAudience
                        ? const MatureAudience()
                        : const SizedBox()
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
