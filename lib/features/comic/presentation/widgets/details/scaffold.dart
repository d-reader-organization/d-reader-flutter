import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/features/comic/presentation/widgets/details/sort_direction.dart';
import 'package:d_reader_flutter/features/comic/presentation/widgets/details/view_mode_container.dart';
import 'package:d_reader_flutter/shared/widgets/layout/animated_app_bar.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/mature_audience.dart';
import 'package:d_reader_flutter/features/comic/presentation/widgets/icons/bookmark_icon.dart';
import 'package:d_reader_flutter/shared/widgets/icons/favorite_icon_count.dart';
import 'package:d_reader_flutter/shared/widgets/icons/rating_icon.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/stats_info.dart';
import 'package:d_reader_flutter/shared/widgets/texts/text_with_view_more.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/avatar.dart';
import 'package:d_reader_flutter/features/discover/genre/presentation/widgets/genre_tags_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ComicDetailsScaffold extends StatefulWidget {
  final Widget body;
  final ComicModel comic;
  final Function() loadMore;

  const ComicDetailsScaffold({
    super.key,
    required this.body,
    required this.comic,
    required this.loadMore,
  });

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
          double maxScroll = notification.metrics.maxScrollExtent;
          double currentScroll = notification.metrics.pixels;
          double delta = MediaQuery.sizeOf(context).width * 0.1;

          if (maxScroll - currentScroll <= delta) {
            widget.loadMore();
          }
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
            actions: [
              GestureDetector(
                onTap: () {
                  nextScreenPush(
                    context: context,
                    path: RoutePath.comicDetailsInfo,
                    extra: widget.comic,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SvgPicture.asset('assets/icons/more.svg'),
                ),
              ),
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
                      height: 320,
                      imageUrl: widget.comic.cover,
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
                          stops: [0.0, .6406, 1],
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
                            Text(
                              widget.comic.title,
                              style: textTheme.headlineLarge,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWithViewMore(
                        text: widget.comic.description,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        onLinkTap: () {
                          nextScreenPush(
                            context: context,
                            path: RoutePath.comicDetailsInfo,
                            extra: widget.comic,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      GenreTagsDefault(
                        genres: widget.comic.genres,
                        withHorizontalScroll: true,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              RatingIcon(
                                initialRating:
                                    widget.comic.stats?.averageRating ?? 0,
                                isRatedByMe:
                                    widget.comic.myStats?.rating != null,
                                comicSlug: widget.comic.slug,
                                isContainerWidget: true,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              FavoriteIconCount(
                                favouritesCount:
                                    widget.comic.stats?.favouritesCount ?? 0,
                                isFavourite:
                                    widget.comic.myStats?.isFavourite ?? false,
                                slug: widget.comic.slug,
                                isContainerWidget: true,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              BookmarkIcon(
                                isBookmarked:
                                    widget.comic.myStats?.isBookmarked ?? false,
                                slug: widget.comic.slug,
                              ),
                            ],
                          ),
                          MatureAudience(
                            audienceType: widget.comic.audienceType,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(
                        thickness: 1,
                        color: ColorPalette.greyscale400,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          nextScreenPush(
                            context: context,
                            path:
                                '${RoutePath.creatorDetails}/${widget.comic.creator?.slug}',
                          );
                        },
                        child: Row(
                          children: [
                            CreatorAvatar(
                              avatar: widget.comic.creator?.avatar ?? '',
                              radius: 24,
                              height: 32,
                              width: 32,
                              slug: widget.comic.creator?.slug ?? '',
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.comic.creator?.name ?? '',
                                style: textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(
                        thickness: 1,
                        color: ColorPalette.greyscale400,
                      ),
                      const SizedBox(
                        height: 8,
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
                  stats:
                      '${Formatter.formatLamportPrice(widget.comic.stats?.totalVolume) ?? 0}◎',
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
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Issues',
                    style: textTheme.headlineMedium,
                  ),
                  widget.comic.stats?.issuesCount != null &&
                          widget.comic.stats!.issuesCount > 1
                      ? const Row(
                          children: [
                            SortDirectionContainer(),
                            SizedBox(
                              width: 8,
                            ),
                            ViewModeContainer(),
                          ],
                        )
                      : const ViewModeContainer(),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8,
              ),
              child: widget.body,
            )
          ],
        ),
      ),
    );
  }
}
