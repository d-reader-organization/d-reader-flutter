import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/comic_issue_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/episode_circle.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:flutter/material.dart';

class ComicIssueCard extends StatelessWidget {
  final ComicIssueModel issue;
  const ComicIssueCard({
    Key? key,
    required this.issue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String episode = '${issue.number}/${issue.stats?.totalIssuesCount}';
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        nextScreenPush(context, ComicIssueDetails(slug: issue.slug));
      },
      child: Container(
        height: 260,
        width: 178,
        decoration: BoxDecoration(
          color: ColorPalette.boxBackground200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImageBgPlaceholder(
              imageUrl: issue.cover,
              cacheKey: 'home${issue.cover}',
              height: 130,
              overrideBorderRadius: const BorderRadius.vertical(
                top: Radius.circular(
                  16,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EpisodeCircle(
                    text: 'EP $episode',
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 4, left: 8, top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    issue.comic?.name ?? 'Missing',
                    style: textTheme.bodyMedium?.copyWith(
                      color: ColorPalette.dReaderYellow100,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    issue.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        issue.creator.name,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Icon(
                        Icons.verified,
                        color: ColorPalette.dReaderYellow100,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SolanaPrice(
                    price: issue.stats!.floorPrice,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
