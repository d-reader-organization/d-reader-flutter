import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/app_bar_without_logo.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/logout_button.dart';
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

class ComicDetailsScaffold extends StatefulWidget {
  final Widget body;
  final ComicModel comic;
  const ComicDetailsScaffold({
    Key? key,
    required this.body,
    required this.comic,
  }) : super(key: key);

  @override
  State<ComicDetailsScaffold> createState() => _ComicDetailsScaffoldState();
}

class _ComicDetailsScaffoldState extends State<ComicDetailsScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = ColorTween(
      begin: Colors.transparent,
      end: ColorPalette.appBackgroundColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollNotification) {
          if (notification.metrics.pixels > 70) {
            _controller.forward();
          } else if (notification.metrics.pixels < 70) {
            _controller.reverse();
          }
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorPalette.appBackgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size(0, 64),
          child: AnimatedAppBar(
            animation: _animation,
            actions: const [
              NotificationBadge(),
              SizedBox(
                width: 8,
              ),
              LogoutButton(),
            ],
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
                      imageUrl: widget.comic.cover,
                      cacheKey: 'details-${widget.comic.slug}',
                      overrideBorderRadius: BorderRadius.circular(0),
                      foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorPalette.appBackgroundColor,
                            Colors.transparent,
                            ColorPalette.appBackgroundColor,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
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
                                  widget.comic.name,
                                  style: textTheme.headlineLarge,
                                ),
                                widget.comic.isPopular
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
                                      widget.comic.flavorText,
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
                              text: widget.comic.description,
                              maxLines: 2,
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
                    right: 16,
                    left: 16,
                    top: 4,
                    bottom: 4,
                  ),
                  child: Column(
                    children: [
                      GenreTagsDefault(genres: widget.comic.genres),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => nextScreenPush(
                              context,
                              CreatorDetailsView(
                                slug: widget.comic.creator.slug,
                              ),
                            ),
                            child: Row(
                              children: [
                                CreatorAvatar(
                                  avatar: widget.comic.creator.avatar,
                                  radius: 24,
                                  height: 32,
                                  width: 32,
                                  slug: widget.comic.creator.slug,
                                ),
                                const SizedBox(width: 12),
                                AuthorVerified(
                                  authorName: widget.comic.creator.name,
                                  isVerified: widget.comic.creator.isVerified,
                                  fontSize: 15,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              RatingIcon(
                                rating: widget.comic.stats?.averageRating ?? 0,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              FavouriteIconCount(
                                favouritesCount:
                                    widget.comic.stats?.favouritesCount ?? 0,
                                isFavourite:
                                    widget.comic.myStats?.isFavourite ?? false,
                                slug: widget.comic.slug,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatsInfo(
                  title: 'VOLUME',
                  stats: '${widget.comic.stats?.totalVolume}◎',
                ),
                StatsInfo(
                  title: 'ISSUES',
                  stats: '${widget.comic.stats?.issuesCount}',
                ),
                StatsInfo(
                  title: 'READERS',
                  stats: '${widget.comic.stats?.readersCount}',
                ),
                StatsInfo(
                  title: widget.comic.isCompleted ? 'COMPLETED' : 'ONGOING',
                  stats: '',
                  statsWidget: Icon(
                    widget.comic.isCompleted
                        ? Icons.check
                        : Icons.arrow_right_alt_outlined,
                    color: Colors.white,
                  ),
                  isLastItem: true,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 2,
              ),
              child: widget.body,
            )
          ],
        ),
      ),
    );
  }
}
