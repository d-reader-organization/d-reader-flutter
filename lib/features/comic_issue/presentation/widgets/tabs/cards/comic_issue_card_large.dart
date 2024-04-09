import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/date_widget.dart';
import 'package:d_reader_flutter/shared/widgets/icons/favorite_icon_count.dart';
import 'package:d_reader_flutter/shared/widgets/icons/rating_icon.dart';
import 'package:d_reader_flutter/shared/widgets/icons/viewed_icon_count.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/solana_price.dart';
import 'package:flutter/material.dart';

class ComicIssueCardLarge extends StatelessWidget {
  final ComicIssueModel issue;

  const ComicIssueCardLarge({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.comicIssueDetails}/${issue.id}',
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 16),
        constraints: const BoxConstraints(
          minHeight: 237,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: comicIssueAspectRatio,
                child: CachedImageBgPlaceholder(
                  imageUrl: issue.cover,
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
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: comicIssueAspectRatio,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: const BoxDecoration(
                    color: ColorPalette.greyscale500,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Episode ${issue.number} of ${issue.stats?.totalIssuesCount}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: ColorPalette.greyscale100,
                        ),
                      ),
                      Text(
                        '${issue.comic?.title}:',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleLarge?.copyWith(
                          color: ColorPalette.greyscale100,
                        ),
                      ),
                      Text(
                        issue.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleLarge,
                      ),
                      const Divider(
                        thickness: 1,
                        color: ColorPalette.greyscale400,
                      ),
                      DateWidget(
                        date: issue.releaseDate,
                      ),
                      const Divider(
                        thickness: 1,
                        color: ColorPalette.greyscale400,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ViewedIconCount(
                            viewedCount: issue.stats?.viewersCount ?? 0,
                            isViewed: issue.myStats?.viewedAt != null,
                          ),
                          FavoriteIconCount(
                            favouritesCount: issue.stats?.favouritesCount ?? 0,
                            isFavourite: issue.myStats?.isFavourite ?? false,
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: ColorPalette.greyscale400,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SolanaPrice(
                            price: issue.stats?.price != null
                                ? Formatter.formatPriceWithSignificant(
                                    issue.stats!.price!,
                                  )
                                : null,
                          ),
                          RatingIcon(
                            initialRating: issue.stats?.averageRating ?? 0,
                            issueId: issue.id,
                            isRatedByMe: issue.myStats?.rating != null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
