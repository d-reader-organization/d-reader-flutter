import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/constants/enums.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_date.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/trigger_walkthrough_dialog.dart';
import 'package:d_reader_flutter/ui/views/comic_details/comic_details.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/tabs/about.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/tabs/listings.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/mature_audience.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ComicIssueDetails extends ConsumerStatefulWidget {
  final int id;
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      triggerWalkthroughDialogIfNeeded(
        context: context,
        key: WalkthroughKeys.issueDetails.name,
        title:
            'Hit the “preview” button to check out the comic! If you want to read the whole story, you’ll have to buy a copy',
        subtitle: '',
        onSubmit: () {
          Navigator.pop(context);
        },
      );
    });
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

    return provider.when(
      data: (issue) {
        if (issue == null) {
          return const SizedBox();
        }
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: ColorPalette.appBackgroundColor,
            extendBodyBehindAppBar: true,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: BottomNavigation(
                issue: issue,
              ),
            ),
            body: NotificationListener(
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
                            centerTitle: true,
                            title: GestureDetector(
                              onTap: () {
                                nextScreenPush(
                                  context,
                                  ComicDetails(
                                    slug: issue.comicSlug,
                                  ),
                                );
                              },
                              child: Text(
                                '${issue.comic?.title}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            // actions: [
                            //   Padding(
                            //     padding: const EdgeInsets.only(
                            //       right: 16,
                            //       top: 4,
                            //     ),
                            //     child:
                            //         SvgPicture.asset('assets/icons/more.svg'),
                            //   ),
                            // ],
                          ),
                        );
                      },
                    ),
                    SliverToBoxAdapter(
                      child: Stack(
                        children: [
                          CachedImageBgPlaceholder(
                            height: 431,
                            imageUrl: issue.cover,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                Container(
                                  height: 304,
                                  width: 214,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        issue.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                                const Text(
                                  'EPISODE  ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ColorPalette.greyscale100,
                                  ),
                                ),
                                Text(
                                  '${issue.number}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  ' / ${issue.stats?.totalIssuesCount}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: ColorPalette.greyscale100,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              issue.title,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    FavouriteIconCount(
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
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      'pages',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorPalette.greyscale100,
                                      ),
                                    ),
                                  ],
                                ),
                                MatureAudience(
                                  audienceType: issue.comic?.audienceType ?? '',
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
                                        Expanded(
                                          child: Text(
                                            issue.creator.name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    formatDateFull(issue.releaseDate),
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
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
                          bottom: 4,
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
                                ? const TabBar(
                                    dividerColor: ColorPalette.dReaderGrey,
                                    indicatorWeight: 4,
                                    indicatorColor:
                                        ColorPalette.dReaderYellow100,
                                    labelColor: ColorPalette.dReaderYellow100,
                                    unselectedLabelColor:
                                        ColorPalette.dReaderGrey,
                                    tabs: [
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
                    vertical: 4,
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
        );
      },
      error: (err, stack) {
        Sentry.captureException(err, stackTrace: stack);
        return const Text(
          'Something went wrong',
          style: TextStyle(color: Colors.red),
        );
      },
      loading: () => const SizedBox(),
    );
  }
}
