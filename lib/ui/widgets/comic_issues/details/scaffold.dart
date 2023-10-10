import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/exceptions.dart';
import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/ui/utils/format_date.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/utils/trigger_bottom_sheet.dart';
import 'package:d_reader_flutter/ui/views/animations/mint_animation_screen.dart';
import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/buy_nft_input.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/providers/auction_house_provider.dart';
import 'package:d_reader_flutter/core/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/views/e_reader.dart';
import 'package:d_reader_flutter/ui/widgets/common/animated_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/mature_audience.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/minting_progress.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:d_reader_flutter/ui/widgets/common/stats_info.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:d_reader_flutter/ui/widgets/library/modals/owned_nfts_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/solana.dart' show lamportsPerSol;

class ComicIssueDetailsScaffold extends ConsumerStatefulWidget {
  final Widget body;
  final ComicIssueModel issue;
  final Function()? loadMore;
  const ComicIssueDetailsScaffold({
    Key? key,
    required this.body,
    required this.issue,
    this.loadMore,
  }) : super(key: key);

  @override
  ConsumerState<ComicIssueDetailsScaffold> createState() =>
      _ComicIssueDetailsScaffoldState();
}

class _ComicIssueDetailsScaffoldState
    extends ConsumerState<ComicIssueDetailsScaffold>
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
            if (widget.loadMore != null) {
              widget.loadMore!();
            }
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
            title: widget.issue.comic?.title,
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 16,
                  top: 4,
                ),
                child: SvgPicture.asset('assets/icons/more.svg'),
              ),
            ],
          ),
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const MintingProgressWidget(
                margin: EdgeInsets.only(
                  top: 72,
                ),
              ),
              Stack(
                children: [
                  CachedImageBgPlaceholder(
                    height: 431,
                    imageUrl: widget.issue.cover,
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
                          height: 309,
                          width: 214,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(
                                widget.issue.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
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
                          '${widget.issue.number}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          ' / ${widget.issue.stats?.totalIssuesCount}',
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
                      widget.issue.title,
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
                        RatingIcon(
                          initialRating: widget.issue.stats?.averageRating ?? 0,
                          isRatedByMe: widget.issue.myStats?.rating != null,
                          issueId: widget.issue.id,
                          isContainerWidget: true,
                        ),
                        FavouriteIconCount(
                          favouritesCount:
                              widget.issue.stats?.favouritesCount ?? 0,
                          isFavourite:
                              widget.issue.myStats?.isFavourite ?? false,
                          issueId: widget.issue.id,
                          isContainerWidget: true,
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.issue.stats?.totalPagesCount} ',
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
                          audienceType: widget.issue.comic?.audienceType ?? '',
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
                                slug: widget.issue.creator.slug,
                              ),
                            ),
                            child: Row(
                              children: [
                                CreatorAvatar(
                                  avatar: widget.issue.creator.avatar,
                                  radius: 24,
                                  height: 32,
                                  width: 32,
                                  slug: widget.issue.creator.slug,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    widget.issue.creator.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
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
                            formatDateFull(widget.issue.releaseDate),
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
              // widget.issue.candyMachineAddress != null
              //     ? CandyMachineStats(
              //         address: widget.issue.candyMachineAddress ?? '',
              //       )
              //     : ListingStats(issue: widget.issue),
              const SizedBox(
                height: 24,
              ),
              widget.body,
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: BottomNavigation(
            issue: widget.issue,
          ),
        ),
      ),
    );
  }
}

class BottomNavigation extends ConsumerWidget {
  final ComicIssueModel issue;
  const BottomNavigation({
    super.key,
    required this.issue,
  });

  _handleMint(BuildContext context, WidgetRef ref) async {
    try {
      final currentWallet =
          ref.watch(environmentProvider).publicKey?.toBase58();
      if (currentWallet == null) {
        await ref.read(solanaProvider.notifier).authorizeAndSignMessage();
      }

      final candyMachine = await ref.read(
        candyMachineProvider(
                query:
                    'candyMachineAddress=${issue.activeCandyMachineAddress}&walletAddress=${ref.watch(environmentProvider).publicKey?.toBase58()}')
            .future,
      );
      final mintResult = await ref.read(solanaProvider.notifier).mint(
            issue.activeCandyMachineAddress,
            candyMachine?.groups
                .firstWhere((element) => element.isActive)
                .label,
          );
      if (context.mounted) {
        if (mintResult is bool && mintResult) {
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
      if (context.mounted && error is NoWalletFoundException) {
        triggerInstallWalletBottomSheet(context);
      }
    }
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
                        onPressed: () async {
                          await _handleMint(context, ref);
                        },
                        text: 'Mint',
                        price: issue.stats?.price,
                      ),
                    )
                  : issue.isSecondarySaleActive
                      ? Expanded(
                          child: TransactionButton(
                            isLoading: ref.watch(globalStateProvider).isLoading,
                            onPressed: ref
                                    .read(selectedItemsProvider)
                                    .isNotEmpty
                                ? () async {
                                    final activeWallet =
                                        ref.read(environmentProvider).publicKey;
                                    if (activeWallet == null) {
                                      throw Exception(
                                          'There is no wallet selected');
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
                                    final isSuccessful = await ref
                                        .read(solanaProvider.notifier)
                                        .buyMultiple(selectedNftsInput);
                                    if (isSuccessful) {
                                      ref.invalidate(listedItemsProvider);
                                      ref.invalidate(userAssetsProvider);
                                    }
                                    ref
                                        .read(globalStateProvider.notifier)
                                        .state
                                        .copyWith(isLoading: false);
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
                  price: formatLamportPrice(price),
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

  openModalBottomSheet(BuildContext context, List<NftModel> ownedNfts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: ownedNfts.length > 1 ? 0.65 : 0.5,
          minChildSize: ownedNfts.length > 1 ? 0.65 : 0.5,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return OwnedNftsBottomSheet(
              ownedNfts: ownedNfts,
              episodeNumber: issue.number,
            );
          },
        );
      },
    );
  }

  fetchOwnedNfts(WidgetRef ref, String comicIssueId) async {
    final globalNotifier = ref.read(globalStateProvider.notifier);
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    final ownedNfts = await ref.read(nftsProvider(
      'comicIssueId=$comicIssueId&userId=${ref.read(environmentProvider).user?.id}',
    ).future);
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );
    return ownedNfts;
  }

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
      onPressed: () async {
        final List<NftModel> ownedNfts =
            await fetchOwnedNfts(ref, '${issue.id}');

        final isAtLeastOneUsed = ownedNfts.any((nft) => nft.isUsed);

        if (context.mounted) {
          if (isAtLeastOneUsed) {
            return nextScreenPush(context, EReaderView(issueId: issue.id));
          }
          openModalBottomSheet(context, ownedNfts);
        }
      },
      child: issue.myStats?.canRead != null && issue.myStats!.canRead
          ? const Row(
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
            )
          : const Text(
              'Preview',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}

class CandyMachineStats extends ConsumerWidget {
  final String address;
  const CandyMachineStats({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(candyMachineProvider(query: address));
    return provider.when(data: (candyMachine) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const StatsInfo(title: 'ENDS IN', stats: ''
              // stats: candyMachine?.endsAt != null
              //     ? timeago.format(
              //         DateTime.parse(candyMachine?.endsAt ?? ''),
              //       )
              //     : '∞',
              ),
          StatsInfo(
            title: 'SUPPLY',
            stats: candyMachine?.supply != null && candyMachine!.supply > 1000
                ? '${candyMachine.supply / 1000}K'
                : '${candyMachine?.supply}',
          ),
          StatsInfo(
            title: 'MINTED',
            stats: '${candyMachine?.itemsMinted}',
          ),
          const StatsInfo(
            title: 'PRICE',
            stats: '-.--◎',
            // stats: candyMachine?.baseMintPrice != null
            //     ? '${formatPrice(formatLamportPrice(candyMachine?.baseMintPrice) ?? 0)}◎'
            //     : '-.--◎',
            isLastItem: true,
          ),
        ],
      );
    }, error: (Object error, StackTrace stackTrace) {
      Sentry.captureException(error, stackTrace: stackTrace);
      return const Text('Something went wrong in candy machine stats');
    }, loading: () {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: SkeletonRow(),
      );
    });
  }
}

class ListingStats extends ConsumerWidget {
  final ComicIssueModel issue;
  const ListingStats({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(collectionStatsProvider(issue.id));

    return provider.when(data: (collectionStats) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatsInfo(
            title: 'VOLUME',
            stats: issue.isFreeToRead
                ? '--'
                : '${collectionStats?.totalVolume != null ? (collectionStats!.totalVolume / lamportsPerSol).toStringAsFixed(2) : 0}◎',
          ),
          const StatsInfo(
              title: 'SUPPLY',
              stats: '--' //issue.isFreeToRead ? '--' : '${issue.supply}',
              ),
          StatsInfo(
            title: 'LISTED',
            stats: issue.isFreeToRead
                ? '--'
                : '${collectionStats?.itemsListed ?? 0}',
          ),
          StatsInfo(
            title: 'PRICE',
            stats: issue.isFreeToRead
                ? 'FREE'
                : '${collectionStats?.floorPrice != null ? formatLamportPrice(collectionStats!.floorPrice) : '--'}◎',
            isLastItem: true,
          ),
        ],
      );
    }, error: (Object error, StackTrace stackTrace) {
      Sentry.captureException(error, stackTrace: stackTrace);
      return const Text('Something went wrong in candy machine stats');
    }, loading: () {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: SkeletonRow(),
      );
    });
  }
}
