import 'package:d_reader_flutter/mint_animation_screen.dart';
import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/buy_nft_input.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/providers/auction_house_provider.dart';
import 'package:d_reader_flutter/core/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_date.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/views/e_reader.dart';
import 'package:d_reader_flutter/ui/widgets/common/animated_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/minting_progress.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:d_reader_flutter/ui/widgets/common/stats_info.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_with_view_more.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/solana.dart' show lamportsPerSol;
import 'package:timeago/timeago.dart' as timeago;

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
                    height: 375,
                    imageUrl: widget.issue.cover,
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
                        children: [
                          Text(
                            widget.issue.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.headlineLarge,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'EP',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${widget.issue.number}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '/${widget.issue.stats?.totalIssuesCount}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.menu_book,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '${widget.issue.stats?.totalPagesCount.toString()} pages',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    formatDate(widget.issue.releaseDate),
                                    style: textTheme.labelMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextWithViewMore(
                            text: widget.issue.description,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
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
                              AuthorVerified(
                                authorName: widget.issue.creator.name,
                                isVerified: widget.issue.creator.isVerified,
                                fontSize: 15,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            RatingIcon(
                              initialRating:
                                  widget.issue.stats?.averageRating ?? 0,
                              isRatedByMe: widget.issue.myStats?.rating != null,
                              issueId: widget.issue.id,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            FavouriteIconCount(
                              favouritesCount:
                                  widget.issue.stats?.favouritesCount ?? 0,
                              isFavourite:
                                  widget.issue.myStats?.isFavourite ?? false,
                              slug: widget.issue.slug,
                              issueId: widget.issue.id,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              widget.issue.candyMachineAddress != null
                  ? CandyMachineStats(
                      address: widget.issue.candyMachineAddress ?? '',
                    )
                  : ListingStats(issue: widget.issue),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return issue.isFree
        ? ReadButton(issue: issue)
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              issue.candyMachineAddress != null
                  ? Expanded(
                      child: TransactionButton(
                        isLoading: ref.watch(globalStateProvider).isLoading,
                        onPressed: () async {
                          try {
                            final isSuccessful = await ref
                                .read(solanaProvider.notifier)
                                .mint(issue.candyMachineAddress);
                            if (isSuccessful && context.mounted) {
                              nextScreenPush(
                                  context, const MintLoadingAnimation());
                            }
                            ref
                                .read(globalStateProvider.notifier)
                                .state
                                .copyWith(isLoading: false);
                          } catch (error) {
                            ref
                                .read(globalStateProvider.notifier)
                                .state
                                .copyWith(isLoading: false);
                          }
                        },
                        text: 'MINT',
                        price: issue.stats?.price,
                      ),
                    )
                  : Expanded(
                      child: TransactionButton(
                        isLoading: ref.watch(globalStateProvider).isLoading,
                        onPressed: ref.read(selectedItemsProvider).isNotEmpty
                            ? () async {
                                List<BuyNftInput> selectedNftsInput = ref
                                    .read(selectedItemsProvider)
                                    .map(
                                      (e) => BuyNftInput(
                                        mintAccount: e.nftAddress,
                                        price: e.price,
                                        seller: e.seller.address,
                                      ),
                                    )
                                    .toList();
                                final isSuccessful = await ref
                                    .read(solanaProvider.notifier)
                                    .buyMultiple(selectedNftsInput);
                                if (isSuccessful) {
                                  ref.invalidate(listedItemsProvider);
                                  ref.invalidate(walletAssetsProvider);
                                }
                                ref
                                    .read(globalStateProvider.notifier)
                                    .state
                                    .copyWith(isLoading: false);
                              }
                            : () {},
                        text: 'BUY',
                        price: ref.watch(selectedItemsPrice),
                        isListing: true,
                      ),
                    ),
              Expanded(
                child: ReadButton(
                  issue: issue,
                ),
              ),
            ],
          );
  }
}

class TransactionButton extends StatelessWidget {
  final bool isLoading;
  final Function() onPressed;
  final String text;
  final int? price;
  final bool isListing;
  const TransactionButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.text,
    this.price,
    this.isListing = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      size: const Size(150, 50),
      isLoading: isLoading,
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

class ReadButton extends StatelessWidget {
  final ComicIssueModel issue;
  const ReadButton({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      size: const Size(150, 50),
      backgroundColor: ColorPalette.dReaderGreen,
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
                  'READ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            )
          : const Text(
              'PREVIEW',
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
    final provider = ref.watch(candyMachineProvider(address));
    return provider.when(data: (candyMachine) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatsInfo(
            title: 'ENDS IN',
            stats: candyMachine?.endsAt != null
                ? timeago.format(
                    DateTime.parse(candyMachine?.endsAt ?? ''),
                  )
                : '∞',
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
          StatsInfo(
            title: 'PRICE',
            stats: candyMachine?.baseMintPrice != null
                ? '${formatPrice(formatLamportPrice(candyMachine?.baseMintPrice) ?? 0)}◎'
                : '-.--◎',
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
            stats: issue.isFree
                ? '--'
                : '${collectionStats?.totalVolume != null ? (collectionStats!.totalVolume / lamportsPerSol).toStringAsFixed(2) : 0}◎',
          ),
          StatsInfo(
            title: 'SUPPLY',
            stats: issue.isFree ? '--' : '${issue.supply}',
          ),
          StatsInfo(
            title: 'LISTED',
            stats: issue.isFree ? '--' : '${collectionStats?.itemsListed ?? 0}',
          ),
          StatsInfo(
            title: 'PRICE',
            stats: issue.isFree
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
