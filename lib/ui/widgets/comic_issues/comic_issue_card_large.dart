import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_date.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/comic_issue_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/viewed_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_with_view_more.dart';
import 'package:flutter/material.dart';

class ComicIssueCardLarge extends StatelessWidget {
  final ComicIssueModel issue;
  const ComicIssueCardLarge({
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
        height: 254,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: CachedImageBgPlaceholder(
                imageUrl: issue.cover,
                cacheKey: 'large-card${issue.slug}',
                overrideBorderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(
                    16,
                  ),
                  bottomLeft: Radius.circular(
                    16,
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white)),
                    child: Text(
                      formatDate(issue.releaseDate),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: ColorPalette.boxBackground300,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EPISODE ${issue.number} of ${issue.stats?.totalIssuesCount}',
                          style: textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFBBBBBB),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          issue.comic?.name ?? 'Missing',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            color: ColorPalette.dReaderYellow100,
                          ),
                        ),
                        Text(
                          issue.title,
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextWithViewMore(
                          text: issue.description,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SolanaPrice(
                          price: issue.stats!.floorPrice,
                        ),
                        ViewedIconCount(
                          viewedCount: issue.stats?.viewersCount ?? 0,
                          isViewed: issue.myStats?.viewedAt != null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
