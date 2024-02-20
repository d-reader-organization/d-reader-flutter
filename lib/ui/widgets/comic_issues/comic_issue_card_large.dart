import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/formatter.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/date_widget.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/viewed_icon_count.dart';
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
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.comicIssueDetails}/${issue.id}',
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        constraints: const BoxConstraints(
          minHeight: 237,
          maxHeight: 237,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: CachedImageBgPlaceholder(
                imageUrl: issue.cover,
                bgImageFit: BoxFit.fill,
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ColorPalette.greyscale100,
                      ),
                    ),
                    Text(
                      '${issue.comic?.title}:',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorPalette.greyscale100,
                      ),
                    ),
                    Text(
                      issue.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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
                        FavouriteIconCount(
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
          ],
        ),
      ),
    );
  }
}
