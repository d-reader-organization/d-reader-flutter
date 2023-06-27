import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/comic_issue_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/date_widget.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/mature_audience.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags_default.dart';
import 'package:flutter/material.dart';

class DiscoverComicIssueCard extends StatelessWidget {
  final ComicIssueModel issue;
  const DiscoverComicIssueCard({
    Key? key,
    required this.issue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreenPush(context, ComicIssueDetails(id: issue.id));
      },
      child: Container(
        height: 165,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: CachedImageBgPlaceholder(
                imageUrl: issue.cover,
                height: 165,
                cacheKey: '${issue.id}',
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorPalette.greyscale100,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    issue.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    'EP ${issue.number}/${issue.stats?.totalIssuesCount}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AuthorVerified(
                        authorName: issue.creator.name,
                        isVerified: issue.creator.isVerified,
                        textColor: ColorPalette.greyscale100,
                        fontSize: 14,
                      ),
                      SolanaPrice(
                        price: formatLamportPrice(issue.stats?.price),
                      ),
                    ],
                  ),
                  const Divider(
                    color: ColorPalette.boxBackground300,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingIcon(
                        initialRating: issue.stats?.averageRating ?? 0,
                        issueId: issue.id,
                        isRatedByMe: issue.myStats?.rating != null,
                      ),
                      DateWidget(
                        date: issue.releaseDate,
                      ),
                      MatureAudience(
                        audienceType: issue.comic?.audienceType ?? '',
                      ),
                    ],
                  ),
                  DiscoverGenreTagsDefault(
                    genres: List<GenreModel>.from(
                      [
                        GenreModel(
                          name: 'Action',
                          slug: 'action',
                          icon:
                              'https://d-reader-dev-mainnet.s3.amazonaws.com/genres/action.svg',
                          color: '#e9a860',
                        ),
                        GenreModel(
                          name: 'Manga',
                          slug: 'manga',
                          icon:
                              'https://d-reader-dev-mainnet.s3.amazonaws.com/genres/manga.svg',
                          color: '#e85a5b',
                        ),
                      ],
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
