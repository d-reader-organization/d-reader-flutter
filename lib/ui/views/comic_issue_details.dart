import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/core/models/buy_nft_input.dart';
import 'package:d_reader_flutter/core/models/candy_machine.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/exceptions.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/notifiers/listings_notifier.dart';
import 'package:d_reader_flutter/core/providers/auction_house_provider.dart';
import 'package:d_reader_flutter/core/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_issue/provider.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/candy_machine_utils.dart';
import 'package:d_reader_flutter/ui/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/ui/utils/format_date.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/utils/trigger_walkthrough_dialog.dart';
import 'package:d_reader_flutter/ui/views/animations/mint_animation_screen.dart';
import 'package:d_reader_flutter/ui/views/comic_details/comic_details.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/views/e_reader.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/tabs/about.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/tabs/listings.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/mature_audience.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                                ? TabBar(
                                    dividerColor: ColorPalette.dReaderGrey,
                                    indicatorWeight: 4,
                                    indicatorColor:
                                        ColorPalette.dReaderYellow100,
                                    labelColor: ColorPalette.dReaderYellow100,
                                    unselectedLabelColor:
                                        ColorPalette.dReaderGrey,
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

  _checkIsVerifiedEmail({required WidgetRef ref}) async {
    final envUser = ref.read(environmentProvider).user;

    if (envUser != null && !envUser.isEmailVerified) {
      final user = await ref.read(myUserProvider.future);
      if (user != null && !user.isEmailVerified) {
        return false;
      }
    }
    return true;
  }

  _handleMint(BuildContext context, WidgetRef ref) async {
    try {
      CandyMachineModel? candyMachineState =
          ref.read(candyMachineStateProvider);
      if (context.mounted && candyMachineState == null) {
        return showSnackBar(
          context: context,
          text: 'Failed to find candy machine',
        );
      }
      final activeGroup = getActiveGroup(candyMachineState!.groups);
      if (activeGroup == null && context.mounted) {
        return showSnackBar(
          context: context,
          text: 'There is no active mint',
        );
      }
      if (activeGroup!.label == dFreeLabel) {
        bool isVerified = await _checkIsVerifiedEmail(ref: ref);
        final user = ref.read(environmentProvider).user;
        Sentry.captureMessage(
          'dFree: User ${user?.email} - isVerified: $isVerified',
        );
        if (!isVerified && context.mounted) {
          return triggerVerificationDialog(context, ref);
        }
      }

      final mintResult = await ref.read(solanaProvider.notifier).mint(
            issue.activeCandyMachineAddress,
            activeGroup.label,
          );
      if (context.mounted) {
        if (mintResult is bool && mintResult) {
          ref.invalidate(nftsProvider);
          nextScreenPush(
            context,
            const MintLoadingAnimation(),
          );
        } else {
          showSnackBar(
            context: context,
            text: mintResult is String ? mintResult : 'Something went wrong',
            backgroundColor: ColorPalette.dReaderRed,
          );
        }
      }
      ref.read(globalStateProvider.notifier).state.copyWith(isLoading: false);
    } catch (error) {
      ref.read(globalStateProvider.notifier).state.copyWith(isLoading: false);
      if (context.mounted) {
        if (error is NoWalletFoundException) {
          return _showWalkthroughDialog(context: context, ref: ref);
        } else if (error is LowPowerModeException) {
          return triggerLowPowerModeDialog(context);
        }
        showSnackBar(
          context: context,
          text: error is BadRequestException ? error.cause : error.toString(),
          backgroundColor: ColorPalette.dReaderRed,
        );
      }
    }
  }

  _showWalkthroughDialog({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    triggerWalkthroughDialog(
      context: context,
      bottomWidget: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Text(
          'Cancel',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      onSubmit: () {
        Navigator.pop(context);
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
        issue.activeCandyMachineAddress == null;
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
              issue.activeCandyMachineAddress != null
                  ? Expanded(
                      child: TransactionButton(
                        isLoading: ref.watch(globalStateProvider).isLoading,
                        onPressed: ref.watch(isOpeningSessionProvider)
                            ? null
                            : () async {
                                if (context.mounted) {
                                  await _handleMint(context, ref);
                                }
                              },
                        text: 'Mint',
                        price:
                            ref.watch(activeCandyMachineGroup)?.mintPrice ?? 0,
                      ),
                    )
                  : issue.isSecondarySaleActive
                      ? Expanded(
                          child: TransactionButton(
                            isLoading: ref.watch(globalStateProvider).isLoading,
                            onPressed: ref
                                        .read(selectedItemsProvider)
                                        .isNotEmpty &&
                                    !ref.watch(isOpeningSessionProvider)
                                ? () async {
                                    final activeWallet =
                                        ref.read(environmentProvider).publicKey;
                                    if (activeWallet == null) {
                                      throw Exception(
                                        'There is no wallet selected',
                                      );
                                    }
                                    List<BuyNftInput> selectedNftsInput = ref
                                        .read(selectedItemsProvider)
                                        .map(
                                          (e) => BuyNftInput(
                                            mintAccount: e.nftAddress,
                                            price: e.price,
                                            sellerAddress: e.seller.address,
                                            buyerAddress:
                                                activeWallet.toBase58(),
                                          ),
                                        )
                                        .toList();
                                    try {
                                      final isSuccessful = await ref
                                          .read(solanaProvider.notifier)
                                          .buyMultiple(selectedNftsInput);
                                      ref
                                          .read(globalStateProvider.notifier)
                                          .state
                                          .copyWith(isLoading: false);
                                      if (isSuccessful) {
                                        ref.invalidate(listedItemsProvider);
                                        ref.invalidate(listingsAsyncProvider);
                                        ref.invalidate(userAssetsProvider);
                                      }
                                      if (context.mounted) {
                                        showSnackBar(
                                          context: context,
                                          text: isSuccessful
                                              ? 'Success!'
                                              : 'Failed to buy item/items.',
                                          backgroundColor: isSuccessful
                                              ? ColorPalette.dReaderGreen
                                              : ColorPalette.dReaderRed,
                                        );
                                      }
                                    } catch (exception) {
                                      ref
                                          .read(globalStateProvider.notifier)
                                          .state
                                          .copyWith(isLoading: false);
                                      if (context.mounted) {
                                        return triggerLowPowerOrNoWallet(
                                          context,
                                          exception,
                                        );
                                      }
                                    }
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
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
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
                      ? formatPriceWithSignificant(price!)
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
          context,
          EReaderView(
            issueId: issue.id,
          ),
        );
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.glasses,
            size: 14,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Read',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
