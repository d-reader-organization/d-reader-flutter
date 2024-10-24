import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/date_widget.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/mature_audience.dart';
import 'package:d_reader_flutter/shared/widgets/icons/favorite_icon_count.dart';
import 'package:d_reader_flutter/shared/widgets/icons/rating_icon.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/price_widget.dart';
import 'package:d_reader_flutter/features/discover/genre/presentation/widgets/genre_tags_default.dart';
import 'package:flutter/material.dart';

class DiscoverComicIssueCard extends StatelessWidget {
  final ComicIssueModel issue;
  const DiscoverComicIssueCard({
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
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 4,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: AspectRatio(
                aspectRatio: comicIssueAspectRatio,
                child: LayoutBuilder(builder: (context, constraints) {
                  return CachedImageBgPlaceholder(
                    imageUrl: issue.cover,
                    cacheHeight: constraints.maxHeight.cacheSize(context),
                    cacheWidth: constraints.maxWidth.cacheSize(context),
                  );
                }),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          issue.comic?.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: ColorPalette.greyscale100,
                          ),
                        ),
                      ),
                      MatureAudience(
                        audienceType: issue.comic?.audienceType ?? '',
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    issue.title,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'EP ${issue.number}/${issue.stats?.totalIssuesCount}',
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          issue.creator.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: textTheme.bodySmall?.copyWith(
                            color: ColorPalette.greyscale100,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: PriceWidget(
                          mainAxisAlignment: MainAxisAlignment.end,
                          price:
                              Formatter.formatLamportPrice(issue.stats?.price),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const Divider(
                    color: ColorPalette.greyscale400,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          RatingIcon(
                            initialRating: issue.stats?.averageRating ?? 0,
                            isRatedByMe: true,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          FavoriteIconCount(
                            favouritesCount: issue.stats?.favouritesCount ?? 0,
                            isFavourite: true,
                          ),
                        ],
                      ),
                      DateWidget(
                        date: issue.releaseDate,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: DiscoverGenreTagsDefault(
                      genres: issue.genres,
                    ),
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
