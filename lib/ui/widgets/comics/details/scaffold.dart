import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/app_bar_without_logo.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/user_icon_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/hot_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/notification_badge.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/stats_info.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_with_view_more.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags_default.dart';
import 'package:flutter/material.dart';

class ComicDetailsScaffold extends StatelessWidget {
  final Widget body;
  final ComicModel comic;
  const ComicDetailsScaffold({
    Key? key,
    required this.body,
    required this.comic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size(0, 64),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: AppBarWithoutLogo(
            actions: [
              NotificationBadge(),
              SizedBox(
                width: 8,
              ),
              UserIconButton(),
            ],
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: const EdgeInsets.only(top: 0),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  CachedImageBgPlaceholder(
                    height: 364,
                    imageUrl: comic.cover,
                    cacheKey: 'details-${comic.slug}',
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
                            children: [
                              Text(
                                comic.name,
                                style: textTheme.headlineLarge,
                              ),
                              comic.isPopular
                                  ? const HotIcon()
                                  : const SizedBox(),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 8),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        width: 3,
                                        color: ColorPalette.dReaderYellow100,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    comic.flavorText,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextWithViewMore(
                            text: comic.description,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 16, left: 16, top: 16, bottom: 4),
                child: Column(
                  children: [
                    GenreTagsDefault(genres: comic.genres),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => nextScreenPush(
                            context,
                            CreatorDetailsView(
                              slug: comic.creator.slug,
                            ),
                          ),
                          child: Row(
                            children: [
                              CreatorAvatar(
                                avatar: comic.creator.avatar,
                                radius: 24,
                                height: 32,
                                width: 32,
                                slug: comic.creator.slug,
                              ),
                              const SizedBox(width: 12),
                              AuthorVerified(
                                authorName: comic.creator.name,
                                isVerified: comic.creator.isVerified,
                                fontSize: 15,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            RatingIcon(
                              rating: comic.stats?.averageRating ?? 0,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            FavouriteIconCount(
                              favouritesCount:
                                  comic.stats?.favouritesCount ?? 0,
                              isFavourite: comic.myStats?.isFavourite ?? false,
                              slug: comic.slug,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatsInfo(
                          title: 'VOLUME',
                          stats: '${comic.stats?.totalVolume}◎',
                        ),
                        StatsInfo(
                          title: 'ISSUES',
                          stats: '${comic.stats?.issuesCount}',
                        ),
                        StatsInfo(
                          title: 'READERS',
                          stats: '${comic.stats?.readersCount}',
                        ),
                        StatsInfo(
                          title: comic.isCompleted ? 'COMPLETED' : 'ONGOING',
                          stats: '',
                          statsWidget: const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.white,
                          ),
                          isLastItem: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 2,
            ),
            child: body,
          )
        ],
      ),
    );
  }
}
