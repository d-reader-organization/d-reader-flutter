import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/description_text.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
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
    return Container(
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
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        issue.comic?.name ?? 'Missing',
                        style: textTheme.titleMedium?.copyWith(
                          color: ColorPalette.dReaderYellow100,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        issue.title,
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DescriptionText(
                        text: issue.description,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SolanaPrice(
                        price: issue.stats!.floorPrice,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.remove_red_eye,
                            color: Color(0xFFE0e0e0),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'DATA',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: const Color(0xFFE0e0e0)),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
