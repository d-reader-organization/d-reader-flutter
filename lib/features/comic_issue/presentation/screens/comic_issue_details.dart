import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/buttons/buy_button.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/buttons/mint_button.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/buttons/read_button.dart';
import 'package:d_reader_flutter/features/creator/presentation/utils/utils.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/utils/render_carrot_error.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/about/about.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/listings/listings.dart';
import 'package:d_reader_flutter/shared/widgets/cards/skeleton_card.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/mature_audience.dart';
import 'package:d_reader_flutter/shared/widgets/icons/favorite_icon_count.dart';
import 'package:d_reader_flutter/shared/widgets/icons/rating_icon.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/skeleton_row.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicIssueDetails extends ConsumerStatefulWidget {
  final String id;
  const ComicIssueDetails({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ComicIssueDetailsState();
}

class _ComicIssueDetailsState extends ConsumerState<ComicIssueDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    ref.read(registerWalletToSocketEvents);
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
    final provider = ref.watch(comicIssueDetailsProvider(widget.id));
    final textTheme = Theme.of(context).textTheme;
    return provider.when(
      data: (issue) {
        return DefaultTabController(
          length: 2,
          initialIndex: issue.isSecondarySaleActive &&
                  issue.activeCandyMachineAddress == null
              ? ref.read(lastSelectedTabIndex)
              : 0,
          child: Scaffold(
            backgroundColor: ColorPalette.appBackgroundColor,
            extendBodyBehindAppBar: true,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: _BottomNavigation(
                issue: issue,
              ),
            ),
            body: SafeArea(
              child: NotificationListener(
                onNotification: (notification) {
                  // if (notification is UserScrollNotification) {
                  //   if (notification.direction == ScrollDirection.forward) {
                  //     _controller.reverse();
                  //   } else if (notification.direction ==
                  //       ScrollDirection.reverse) {
                  //     _controller.forward();
                  //   }
                  // }
                  if (notification is ScrollEndNotification) {
                    if (notification.metrics.pixels > 70) {
                      _controller.forward();
                    } else if (notification.metrics.pixels < 70) {
                      _controller.reverse();
                    }
                  }
                  return true;
                },
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (BuildContext context, Widget? child) {
                          return SliverOverlapAbsorber(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                              context,
                            ),
                            sliver: SliverAppBar(
                              pinned: true,
                              backgroundColor: _animation.value,
                              shadowColor: Colors.transparent,
                              surfaceTintColor: _animation.value,
                              centerTitle: true,
                              title: GestureDetector(
                                onTap: () {
                                  nextScreenPush(
                                    context: context,
                                    path:
                                        '${RoutePath.comicDetails}/${issue.comicSlug}',
                                  );
                                },
                                child: Text(
                                  '${issue.comic?.title}',
                                  style: textTheme.headlineMedium,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SliverToBoxAdapter(
                        child: Stack(
                          children: [
                            CachedImageBgPlaceholder(
                              height: MediaQuery.sizeOf(context).height > 780
                                  ? 431
                                  : 460,
                              imageUrl: issue.cover,
                              cacheHeight:
                                  (MediaQuery.sizeOf(context).height > 780
                                          ? 431
                                          : 460)
                                      .cacheSize(context),
                              overrideBorderRadius: BorderRadius.circular(0),
                              foregroundDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ColorPalette.appBackgroundColor,
                                    const Color(0xff181a20).withOpacity(.8),
                                    ColorPalette.appBackgroundColor,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  stops: const [0.0, .6406, 1],
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: GestureDetector(
                                onTap: () {
                                  nextScreenPush(
                                    context: context,
                                    path: RoutePath.comicIssueCover,
                                    extra: issue.cover,
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                        bottom: 32,
                                      ),
                                      constraints: const BoxConstraints(
                                        maxWidth: 220,
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: comicIssueAspectRatio,
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return CachedImageBgPlaceholder(
                                            imageUrl: issue.cover,
                                            cacheWidth: constraints.maxWidth
                                                .cacheSize(context),
                                            cacheHeight: constraints.maxHeight
                                                .cacheSize(context),
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'EPISODE  ',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: ColorPalette.greyscale100,
                                    ),
                                  ),
                                  Text(
                                    '${issue.number}',
                                    style: textTheme.titleMedium,
                                  ),
                                  Text(
                                    ' / ${issue.stats?.totalIssuesCount}',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: ColorPalette.greyscale100,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                issue.title,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: textTheme.headlineLarge,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      RatingIcon(
                                        initialRating:
                                            issue.stats?.averageRating ?? 0,
                                        isRatedByMe:
                                            issue.myStats?.rating != null,
                                        issueId: issue.id,
                                        isContainerWidget: true,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      FavoriteIconCount(
                                        favouritesCount:
                                            issue.stats?.favouritesCount ?? 0,
                                        isFavourite:
                                            issue.myStats?.isFavourite ?? false,
                                        issueId: issue.id,
                                        isContainerWidget: true,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${issue.stats?.totalPagesCount} ',
                                        style: textTheme.bodyMedium,
                                      ),
                                      Text(
                                        'pages',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: ColorPalette.greyscale100,
                                        ),
                                      ),
                                    ],
                                  ),
                                  MatureAudience(
                                    audienceType:
                                        issue.comic?.audienceType ?? '',
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
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: GestureDetector(
                                      onTap: () {
                                        nextScreenPush(
                                          context: context,
                                          path:
                                              '${RoutePath.creatorDetails}/${issue.creator.slug}',
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          renderAvatar(
                                            context: context,
                                            creator: issue.creator,
                                            height: 24,
                                            width: 24,
                                          ),
                                          // CreatorAvatar(
                                          //   avatar: issue.creator.avatar,
                                          //   radius: 24,
                                          //   height: 32,
                                          //   width: 32,
                                          // ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              issue.creator.name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: textTheme.titleMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Formatter.formatDateFull(
                                          issue.releaseDate),
                                      textAlign: TextAlign.end,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: ColorPalette.greyscale100,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                          ),
                          child: Stack(
                            fit: StackFit.passthrough,
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: ColorPalette.greyscale400,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                              issue.isSecondarySaleActive &&
                                      issue.activeCandyMachineAddress == null
                                  ? TabBar(
                                      onTap: (value) {
                                        ref
                                            .read(lastSelectedTabIndex.notifier)
                                            .update((state) => value);
                                      },
                                      tabs: const [
                                        Tab(
                                          text: 'About',
                                        ),
                                        Tab(
                                          text: 'Listings',
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: issue.isSecondarySaleActive
                        ? TabBarView(
                            children: [
                              IssueAbout(issue: issue),
                              IssueListings(
                                issue: issue,
                              ),
                            ],
                          )
                        : IssueAbout(issue: issue),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      error: (err, stack) {
        return renderCarrotErrorWidget(ref);
      },
      loading: () => const _ComicIssueDetailsSkeleton(),
    );
  }
}

class _BottomNavigation extends ConsumerWidget {
  final ComicIssueModel issue;
  const _BottomNavigation({
    required this.issue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ReadButton(
              issue: issue,
            ),
          ),
          issue.activeCandyMachineAddress != null
              ? Expanded(
                  child: MintButton(
                    activeCandyMachineAddress: issue.activeCandyMachineAddress!,
                  ),
                )
              : issue.isSecondarySaleActive
                  ? const Expanded(
                      child: BuyButton(),
                    )
                  : const SizedBox(),
        ],
      ),
    );
  }
}

class _ComicIssueDetailsSkeleton extends StatelessWidget {
  const _ComicIssueDetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: const SafeArea(
        child: SkeletonRow(),
      ),
      body: ListView(
        children: [
          SkeletonCard(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height > 780 ? 431 : 460,
            gradient: LinearGradient(
              colors: [
                ColorPalette.appBackgroundColor,
                const Color(0xff181a20).withOpacity(.8),
                ColorPalette.appBackgroundColor,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [0.0, .6406, 1],
            ),
          ),
          const SkeletonRow(
            margin: EdgeInsets.only(top: 16, bottom: 8),
          ),
          const SkeletonRow(
            margin: EdgeInsets.only(bottom: 16),
          ),
          const SkeletonRow(
            margin: EdgeInsets.only(bottom: 8),
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
    );
  }
}
