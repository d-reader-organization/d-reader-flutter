import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:d_reader_flutter/ui/utils/home_cards_width.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/comic_issue_details2.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/hot_icon.dart';
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
    TextTheme textTheme = Theme.of(context).textTheme;
    final double cardWidth = getCardWidth(MediaQuery.sizeOf(context).width);
    return GestureDetector(
      onTap: () {
        nextScreenPush(
            context,
            ComicIssueDetails2(
              id: issue.id,
            ));
      },
      child: Container(
        width: cardWidth,
        constraints: const BoxConstraints(maxWidth: 190),
        margin: const EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            CachedImageBgPlaceholder(
              imageUrl: issue.cover,
              width: cardWidth,
              padding: EdgeInsets.zero,
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [
                    ColorPalette.greyscale500,
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.0, .5],
                ),
              ),
              child: issue.isPopular
                  ? const Align(
                      alignment: Alignment.topLeft,
                      child: HotIconSmall(),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    issue.comic?.title ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: textTheme.titleSmall?.copyWith(
                      color: ColorPalette.greyscale100,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    issue.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EP ${issue.number}/${issue.stats?.totalIssuesCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SolanaPrice(
                        price: formatLamportPrice(issue.stats?.price),
                        mainAxisAlignment: MainAxisAlignment.end,
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
