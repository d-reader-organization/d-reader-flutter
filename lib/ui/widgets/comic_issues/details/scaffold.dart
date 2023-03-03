import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_date.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/views/e_reader.dart';
import 'package:d_reader_flutter/ui/widgets/common/app_bar_without_logo.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/buy_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:d_reader_flutter/ui/widgets/common/stats_info.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_with_view_more.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ComicIssueDetailsScaffold extends StatelessWidget {
  final Widget body;
  final ComicIssueModel issue;
  const ComicIssueDetailsScaffold({
    Key? key,
    required this.body,
    required this.issue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size(0, 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: AppBarWithoutLogo(
            title: issue.comic?.name,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 0),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Stack(
            children: [
              CachedImageBgPlaceholder(
                height: 364,
                imageUrl: issue.cover,
                cacheKey: 'details-${issue.slug}',
                overrideBorderRadius: BorderRadius.circular(0),
                foregroundDecoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorPalette.appBackgroundColor,
                      Colors.transparent,
                      ColorPalette.appBackgroundColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.128, .6406, 1],
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EPISODE',
                                style: textTheme.bodyMedium,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${issue.number}',
                                    style: textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    '/${issue.stats?.totalIssuesCount}',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: ColorPalette.dReaderGrey
                                          .withOpacity(0.5),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${issue.stats?.totalPagesCount.toString()} pages',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                issue.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.headlineLarge,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                formatDate(issue.releaseDate),
                                style: textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextWithViewMore(
                        text: issue.description,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => nextScreenPush(
                        context,
                        CreatorDetailsView(
                          slug: issue.creator.slug,
                        ),
                      ),
                      child: Row(
                        children: [
                          CreatorAvatar(
                            avatar: issue.creator.avatar,
                            radius: 24,
                            height: 32,
                            width: 32,
                            slug: issue.creator.slug,
                          ),
                          const SizedBox(width: 12),
                          AuthorVerified(
                            authorName: issue.creator.name,
                            isVerified: issue.creator.isVerified,
                            fontSize: 15,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        RatingIcon(
                          rating: issue.stats?.averageRating ?? 0,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        FavouriteIconCount(
                          favouritesCount: issue.stats?.favouritesCount ?? 0,
                          isFavourite: issue.myStats?.isFavourite ?? false,
                          slug: issue.slug,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                issue.candyMachineAddress == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatsInfo(
                            title: 'ENDS IN',
                            stats: '${issue.stats?.totalVolume}◎',
                          ),
                          StatsInfo(
                            title: 'SUPPLY',
                            stats: '${issue.supply}',
                          ),
                          StatsInfo(
                            title: 'MINTED',
                            stats: '${issue.stats?.totalListedCount}',
                          ),
                          StatsInfo(
                            title: 'PRICE',
                            stats: '${issue.stats?.floorPrice ?? '-.--'}◎',
                            isLastItem: true,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatsInfo(
                            title: 'VOLUME',
                            stats: '${issue.stats?.totalVolume}◎',
                          ),
                          StatsInfo(
                            title: 'SUPPLY',
                            stats: '${issue.supply}',
                          ),
                          StatsInfo(
                            title: 'LISTED',
                            stats: '${issue.stats?.totalListedCount}',
                          ),
                          StatsInfo(
                            title: 'FLOOR',
                            stats: '${issue.stats?.floorPrice ?? '-.--'}◎',
                            isLastItem: true,
                          ),
                        ],
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: body,
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BuyButton(
            size: const Size(180, 50),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'MINT',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                SolanaPrice(
                  price: issue.stats?.floorPrice,
                  textColor: Colors.black,
                )
              ],
            ),
          ),
          BuyButton(
            size: const Size(180, 50),
            backgroundColor: ColorPalette.dReaderGreen,
            onPressed: () {
              nextScreenPush(
                context,
                EReaderView(
                  issueId: issue.id,
                ),
              );
            },
            child: issue.myStats?.canRead != null && issue.myStats!.canRead
                ? Row(
                    children: const [
                      Icon(
                        FontAwesomeIcons.glasses,
                        size: 14,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'READ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  )
                : const Text(
                    'PREVIEW',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
