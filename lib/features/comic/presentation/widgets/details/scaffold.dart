import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/features/comic/presentation/widgets/details/sort_direction.dart';
import 'package:d_reader_flutter/features/comic/presentation/widgets/details/view_mode_container.dart';
import 'package:d_reader_flutter/shared/widgets/cards/skeleton_card.dart';
import 'package:d_reader_flutter/shared/widgets/layout/animated_app_bar.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/mature_audience.dart';
import 'package:d_reader_flutter/features/comic/presentation/widgets/icons/bookmark_icon.dart';
import 'package:d_reader_flutter/shared/widgets/icons/favorite_icon_count.dart';
import 'package:d_reader_flutter/shared/widgets/icons/rating_icon.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/skeleton_row.dart';
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
    return Scaffold(
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
                child: SvgPicture.asset('assets/icons/more_with_border.svg'),
              ),
            ),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      body: NotificationListener(
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
        child: ListView(
          padding: const EdgeInsets.only(top: 0),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Column(
              children: [
                _ComicBannerHeader(comic: widget.comic),
                _BelowBannerContent(comic: widget.comic),
              ],
            ),
            _ComicStatsRow(comic: widget.comic),
            const SizedBox(
              height: 16,
            ),
            _BodyFilters(comic: widget.comic),
            const SizedBox(
              height: 16,
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

class _ComicBannerHeader extends StatelessWidget {
  final ComicModel comic;
  const _ComicBannerHeader({required this.comic});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: comicAspectRatio,
          child: LayoutBuilder(builder: (context, constraints) {
            return CachedImageBgPlaceholder(
              imageUrl: comic.cover,
              cacheHeight: constraints.maxHeight.cacheSize(context),
              cacheWidth: constraints.maxWidth.cacheSize(context),
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
            );
          }),
        ),
        Positioned.fill(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: AspectRatio(
              aspectRatio: .6,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return CachedNetworkImage(
                    imageUrl: comic.logo,
                    memCacheHeight: 100,
                  );
                },
              ),
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
                  comic.title,
                  style: textTheme.headlineLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BelowBannerContent extends StatelessWidget {
  final ComicModel comic;
  const _BelowBannerContent({required this.comic});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            text: comic.description,
            maxLines: 2,
            textAlign: TextAlign.start,
            onLinkTap: () {
              nextScreenPush(
                context: context,
                path: RoutePath.comicDetailsInfo,
                extra: comic,
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          GenreTagsDefault(
            genres: comic.genres,
            withHorizontalScroll: true,
          ),
          const SizedBox(
            height: 16,
          ),
          _ActionsRow(comic: comic),
          const _DividerLine(),
          GestureDetector(
            onTap: () {
              nextScreenPush(
                context: context,
                path: '${RoutePath.creatorDetails}/${comic.creator?.slug}',
              );
            },
            child: Row(
              children: [
                CreatorAvatar(
                  avatar: comic.creator?.avatar ?? '',
                  radius: 24,
                  height: 32,
                  width: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    comic.creator?.name ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const _DividerLine(),
        ],
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final ComicModel comic;
  const _ActionsRow({required this.comic});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            RatingIcon(
              initialRating: comic.stats?.averageRating ?? 0,
              isRatedByMe: comic.myStats?.rating != null,
              comicSlug: comic.slug,
              isContainerWidget: true,
            ),
            const SizedBox(
              width: 8,
            ),
            FavoriteIconCount(
              favouritesCount: comic.stats?.favouritesCount ?? 0,
              isFavourite: comic.myStats?.isFavourite ?? false,
              slug: comic.slug,
              isContainerWidget: true,
            ),
            const SizedBox(
              width: 8,
            ),
            BookmarkIcon(
              isBookmarked: comic.myStats?.isBookmarked ?? false,
              slug: comic.slug,
            ),
          ],
        ),
        MatureAudience(
          audienceType: comic.audienceType,
        ),
      ],
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        thickness: 1,
        color: ColorPalette.greyscale400,
      ),
    );
  }
}

class _ComicStatsRow extends StatelessWidget {
  final ComicModel comic;
  const _ComicStatsRow({required this.comic});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatsInfo(
          title: 'TOTAL VOL',
          stats:
              '${Formatter.formatLamportPrice(comic.stats?.totalVolume) ?? 0}',
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
          statsWidget: Icon(
            comic.isCompleted ? Icons.check : Icons.arrow_right_alt_outlined,
            color: Colors.white,
          ),
          isLastItem: true,
        ),
      ],
    );
  }
}

class _BodyFilters extends StatelessWidget {
  final ComicModel comic;
  const _BodyFilters({required this.comic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Issues',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          comic.stats?.issuesCount != null && comic.stats!.issuesCount > 1
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
    );
  }
}

class ComicDetailsSkeleton extends StatelessWidget {
  const ComicDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 64,
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: const EdgeInsets.only(top: 0),
        children: const [
          AspectRatio(
            aspectRatio: comicAspectRatio,
            child: SkeletonCard(
              width: double.infinity,
              height: double.infinity,
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
          Padding(
            padding: EdgeInsets.only(
              right: 16,
              left: 16,
              top: 4,
              bottom: 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonRow(
                  margin: EdgeInsets.only(bottom: 16),
                ),
                SkeletonRow(
                  margin: EdgeInsets.only(bottom: 16),
                ),
                SkeletonRow(),
                _DividerLine(),
                SkeletonRow(),
                _DividerLine(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
