import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/comic_issue_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/date_widget.dart';
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
    return GestureDetector(
      onTap: () {
        nextScreenPush(context, ComicIssueDetails(id: issue.id));
      },
      child: Container(
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
                      text:
                          'EP ${issue.number}/${issue.stats?.totalIssuesCount}',
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                    height: 8,
                  ),
                  AuthorVerified(
                    authorName: issue.creator.name,
                    isVerified: issue.creator.isVerified,
                    textColor: const Color(0xFFb9b9b9),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  DateWidget(
                    date: issue.releaseDate,
                  ),
                  const SizedBox(
                    height: 4,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FLOOR',
                            style: textTheme.labelSmall,
                          ),
                          Text(
                            '${formatPrice(issue.stats?.floorPrice ?? 0)}◎',
                            style: textTheme.labelSmall?.copyWith(
                              color: ColorPalette.dReaderYellow100,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VOLUME',
                            style: textTheme.labelSmall,
                          ),
                          Text(
                            '${issue.stats?.totalVolume.toStringAsFixed(1)}◎',
                            style: textTheme.labelSmall,
                          ),
                        ],
                      ),
                      ViewedIconCount(
                        viewedCount: issue.stats?.viewersCount ?? 0,
                        isViewed: issue.myStats?.viewedAt != null,
                      ),
                      issue.comic?.isMatureAudience != null &&
                              issue.comic!.isMatureAudience
                          ? const MatureAudience()
                          : const SizedBox(
                              width: 22,
                              height: 16,
                            )
                    ],
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
