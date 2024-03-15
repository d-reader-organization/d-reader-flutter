import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/auction_house/presentation/providers/auction_house_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/controller/comic_issue_controller.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_providers.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/about/about.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/listings/listings.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/mature_audience.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
                                    onTap: () {
                                      nextScreenPush(
                                        context: context,
                                        path:
                                            '${RoutePath.creatorDetails}/${issue.creator.slug}',
                                      );
                                    },
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
                                    Formatter.formatDateFull(issue.releaseDate),
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
                                ? TabBar(
                                    indicatorWeight: 4,
                                    dividerColor: ColorPalette.greyscale200,
                                    labelStyle:
                                        Theme.of(context).textTheme.titleMedium,
                                    unselectedLabelStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                    indicatorColor:
                                        ColorPalette.dReaderYellow100,
                                    labelColor: ColorPalette.dReaderYellow100,
                                    unselectedLabelColor:
                                        ColorPalette.greyscale200,
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
        return const Center(
          child: Text(
            'Failed to fetch data',
            style: TextStyle(color: Colors.red),
          ),
        );
      },
      loading: () => const SizedBox(),
    );
  }
}

class BottomNavigation extends ConsumerWidget {
  final ComicIssueModel issue;
  const BottomNavigation({
    super.key,
    required this.issue,
  });

  void _showWalkthroughDialog({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    triggerWalkthroughDialog(
      context: context,
      bottomWidget: GestureDetector(
        onTap: () {
          context.pop();
        },
        child: Text(
          'Cancel',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                decoration: TextDecoration.underline,
              ),
        ),
      ),
      onSubmit: () {
        context.pop();
        triggerInstallWalletBottomSheet(context);
      },
      assetPath: '$walkthroughAssetsPath/install_wallet.jpg',
      title: 'Install a wallet',
      subtitle:
          'To buy a digital asset you need to have a digital wallet installed first. Click “Next” to set up a wallet!',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool canRead =
        issue.myStats?.canRead != null && issue.myStats!.canRead;
    final bool showReadButtonOnly = issue.isFreeToRead &&
        canRead &&
        issue.activeCandyMachineAddress == null &&
        !issue.isSecondarySaleActive;
    return showReadButtonOnly
        ? ReadButton(issue: issue)
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ReadButton(
                  issue: issue,
                ),
              ),
              ref.watch(activeCandyMachineGroup) != null
                  ? Expanded(
                      child: TransactionButton(
                        isLoading: ref.watch(globalNotifierProvider).isLoading,
                        onPressed: ref.watch(isOpeningSessionProvider)
                            ? null
                            : () async {
                                await ref
                                    .read(comicIssueControllerProvider.notifier)
                                    .handleMint(
                                  displaySnackbar: ({
                                    required String text,
                                    bool isError = false,
                                  }) {
                                    showSnackBar(
                                      context: context,
                                      text: text,
                                      backgroundColor: isError
                                          ? ColorPalette.dReaderRed
                                          : ColorPalette.greyscale300,
                                    );
                                  },
                                  triggerVerificationDialog: () {
                                    return triggerVerificationDialog(
                                        context, ref);
                                  },
                                  onSuccessMint: () {
                                    nextScreenPush(
                                      context: context,
                                      path: RoutePath.mintLoadingAnimation,
                                    );
                                  },
                                  onException: (exception) {
                                    if (exception is NoWalletFoundException) {
                                      return _showWalkthroughDialog(
                                          context: context, ref: ref);
                                    } else if (exception
                                        is LowPowerModeException) {
                                      return triggerLowPowerModeDialog(context);
                                    }
                                    showSnackBar(
                                      context: context,
                                      text: exception is BadRequestException
                                          ? exception.cause
                                          : exception.toString(),
                                      backgroundColor: ColorPalette.dReaderRed,
                                    );
                                  },
                                );
                              },
                        text: 'Mint',
                        price:
                            ref.watch(activeCandyMachineGroup)?.mintPrice ?? 0,
                      ),
                    )
                  : issue.isSecondarySaleActive
                      ? Expanded(
                          child: TransactionButton(
                            isLoading:
                                ref.watch(globalNotifierProvider).isLoading,
                            onPressed:
                                ref.read(selectedItemsProvider).isNotEmpty &&
                                        !ref.watch(isOpeningSessionProvider)
                                    ? () async {
                                        await ref
                                            .read(comicIssueControllerProvider
                                                .notifier)
                                            .handleBuy(
                                          displaySnackBar: ({
                                            required String text,
                                            required bool isSuccess,
                                          }) {
                                            showSnackBar(
                                              context: context,
                                              text: text,
                                              backgroundColor: isSuccess
                                                  ? ColorPalette.dReaderGreen
                                                  : ColorPalette.dReaderRed,
                                            );
                                          },
                                          onException: (exception) {
                                            triggerLowPowerOrNoWallet(
                                              context,
                                              exception,
                                            );
                                          },
                                        );
                                      }
                                    : null,
                            text: 'Buy',
                            price: ref.watch(selectedItemsPrice),
                            isListing: true,
                          ),
                        )
                      : const SizedBox(),
            ],
          );
  }
}

class TransactionButton extends StatelessWidget {
  final bool isLoading;
  final Function()? onPressed;
  final String text;
  final int? price;
  final bool isListing;
  const TransactionButton({
    super.key,
    required this.isLoading,
    this.onPressed,
    required this.text,
    this.price,
    this.isListing = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      size: const Size(150, 50),
      isLoading: isLoading,
      fontSize: 16,
      borderRadius: const BorderRadius.all(
        Radius.circular(
          8,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.black,
                ),
          ),
          const SizedBox(
            width: 4,
          ),
          isListing && price == null
              ? Image.asset(
                  Config.solanaLogoPath,
                  width: 14,
                  height: 10,
                )
              : SolanaPrice(
                  price: price != null && price! > 0
                      ? Formatter.formatPriceWithSignificant(price!)
                      : null,
                  textColor: Colors.black,
                ),
        ],
      ),
    );
  }
}

class ReadButton extends ConsumerWidget {
  final ComicIssueModel issue;
  const ReadButton({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTextButton(
      size: const Size(150, 50),
      backgroundColor: Colors.transparent,
      borderColor: ColorPalette.greyscale50,
      textColor: ColorPalette.greyscale50,
      fontSize: 16,
      borderRadius: const BorderRadius.all(
        Radius.circular(
          8,
        ),
      ),
      onPressed: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.eReader}/${issue.id}',
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            FontAwesomeIcons.glasses,
            size: 14,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            'Read',
            style: Theme.of(context).textTheme.titleSmall,
          )
        ],
      ),
    );
  }
}
