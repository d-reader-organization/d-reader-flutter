import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/core/providers/discover/filter_provider.dart';
import 'package:d_reader_flutter/core/providers/discover/view_mode.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/formatter.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/widgets/common/animated_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/mature_audience.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/bookmark_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/stats_info.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_with_view_more.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicDetailsScaffold extends StatefulWidget {
  final Widget body;
  final ComicModel comic;
  final Function() loadMore;
  const ComicDetailsScaffold({
    Key? key,
    required this.body,
    required this.comic,
    required this.loadMore,
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
                            // ClipRect(
                            //   child: BackdropFilter(
                            //     filter: ImageFilter.blur(
                            //       sigmaX: 10,
                            //       sigmaY: 10,
                            //     ),
                            //     child: Container(
                            //       padding: const EdgeInsets.symmetric(
                            //         horizontal: 6,
                            //         vertical: 4,
                            //       ),
                            //       decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(4),
                            //         backgroundBlendMode: BlendMode.darken,
                            //         color: ColorPalette.boxBackground300,
                            //       ),
                            //       child: const Text(
                            //         'NEW EPISODES!',
                            //         style: TextStyle(
                            //           fontSize: 12,
                            //           fontWeight: FontWeight.w500,
                            //           letterSpacing: .2,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(
                            //   height: 12,
                            // ),
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
                              FavouriteIconCount(
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
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
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
                  const Text(
                    'Issues',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
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

class BodyFilterAndSortContainer extends StatelessWidget {
  final Widget child;
  const BodyFilterAndSortContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(
          minHeight: 36,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: ColorPalette.greyscale500,
          border: Border.all(
            color: ColorPalette.greyscale300,
          ),
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: child);
  }
}

class SortDirectionContainer extends ConsumerWidget {
  const SortDirectionContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(comicSortDirectionProvider.notifier).update(
              (state) => state == SortDirection.asc
                  ? SortDirection.desc
                  : SortDirection.asc,
            );
      },
      child: BodyFilterAndSortContainer(
        child: Row(
          children: [
            const Text(
              'Ep No',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            ref.watch(comicSortDirectionProvider) == SortDirection.asc
                ? SvgPicture.asset(
                    'assets/icons/arrow_down.svg',
                    height: 18,
                    width: 18,
                  )
                : RotationTransition(
                    turns: const AlwaysStoppedAnimation(
                      180 / 360,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/arrow_down.svg',
                      height: 18,
                      width: 18,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class ViewModeContainer extends ConsumerWidget {
  const ViewModeContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(comicViewModeProvider.notifier).update((state) =>
            state == ViewMode.detailed ? ViewMode.gallery : ViewMode.detailed);
      },
      child: BodyFilterAndSortContainer(
          child: Row(
        children: [
          const Text(
            'View',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          ref.watch(comicViewModeProvider) == ViewMode.detailed
              ? SvgPicture.asset('assets/icons/category.svg')
              : SvgPicture.asset('assets/icons/list.svg'),
        ],
      )),
    );
  }
}
