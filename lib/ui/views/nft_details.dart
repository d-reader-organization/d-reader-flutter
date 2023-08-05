import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/shorten_nft_name.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/views/animations/open_nft_animation_screen.dart';
import 'package:d_reader_flutter/ui/views/comic_issue_details.dart';
import 'package:d_reader_flutter/ui/views/e_reader.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/nft_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/rarity.dart';
import 'package:d_reader_flutter/ui/widgets/common/royalty.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_with_view_more.dart';
import 'package:d_reader_flutter/ui/widgets/nft/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

const sectionHeadingStyle = TextStyle(
  color: Color(0xFF777D8C),
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

class NftDetails extends ConsumerWidget {
  final String address;
  const NftDetails({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(nftProvider(address));

    return provider.when(
      data: (nft) {
        if (nft == null) {
          return const Text('Something went wrong.');
        }
        return Scaffold(
          backgroundColor: ColorPalette.appBackgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  shortenNftName(nft.name),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                sliver: SliverToBoxAdapter(
                  child: NfTCard(
                    comicName: nft.comicName,
                    imageUrl: nft.image,
                    issueName: nft.comicIssueName,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Body(nft: nft),
              ),
            ],
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        Sentry.captureException(error, stackTrace: stackTrace);
        return const Text('Something went wrong in nft details.');
      },
      loading: () {
        return Scaffold(
          backgroundColor: ColorPalette.appBackgroundColor,
          appBar: AppBar(
            backgroundColor: ColorPalette.appBackgroundColor,
          ),
          body: ListView(
            children: const [
              SkeletonCard(
                height: 328,
              ),
              SizedBox(
                height: 8,
              ),
              SkeletonRow(),
              SizedBox(
                height: 8,
              ),
              SkeletonRow(),
              SizedBox(
                height: 8,
              ),
              SkeletonRow(),
            ],
          ),
        );
      },
    );
  }
}

class Body extends StatelessWidget {
  final NftModel nft;
  const Body({
    super.key,
    required this.nft,
  });

  _handleNftOpen(BuildContext context, bool isSuccessful) {
    if (isSuccessful) {
      return nextScreenPush(
        context,
        const OpenNftAnimation(),
      );
    }
    showSnackBar(
      context: context,
      backgroundColor: ColorPalette.dReaderRed,
      milisecondsDuration: 2000,
      text: 'Failed to open',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const PageScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  return Expanded(
                    child: CustomTextButton(
                      size: Size(MediaQuery.sizeOf(context).width / 2.4, 50),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          8,
                        ),
                      ),
                      borderColor: ColorPalette.greyscale200,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Colors.transparent,
                      isLoading: ref.watch(globalStateProvider).isLoading,
                      child: nft.isListed
                          ? const Text(
                              'Delist',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPalette.greyscale200),
                            )
                          : const Text(
                              'List',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: ColorPalette.greyscale200),
                            ),
                      onPressed: () async {
                        if (nft.isListed) {
                          await ref
                              .read(solanaProvider.notifier)
                              .delist(nftAddress: nft.address);
                          ref.invalidate(nftProvider);
                          ref.read(globalStateProvider.notifier).state =
                              const GlobalState(isLoading: false);
                          return;
                        }
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.viewInsetsOf(context).bottom,
                              ),
                              child: NftModalBottomSheet(nft: nft),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                width: 16,
              ),
              Consumer(
                builder: (context, ref, child) {
                  return Expanded(
                    child: CustomTextButton(
                      backgroundColor: Colors.transparent,
                      borderColor: ColorPalette.dReaderGreen,
                      size: Size(MediaQuery.sizeOf(context).width / 2.4, 50),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          8,
                        ),
                      ),
                      child: Text(
                        nft.isUsed ? 'Read' : 'Open',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ColorPalette.dReaderGreen,
                        ),
                      ),
                      onPressed: () async {
                        if (nft.isUsed) {
                          return nextScreenPush(
                            context,
                            EReaderView(
                              issueId: nft.comicIssueId,
                            ),
                          );
                        }
                        final isSuccessful =
                            await ref.read(solanaProvider.notifier).useMint(
                                  nftAddress: nft.address,
                                  ownerAddress: nft
                                      .ownerAddress, // TODO: we have to make sure that we sign this action with the correct wallet (auth_token)
                                );
                        if (context.mounted) {
                          _handleNftOpen(context, isSuccessful);
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Description',
            style: sectionHeadingStyle,
          ),
          const SizedBox(
            height: 4,
          ),
          TextWithViewMore(
            text: nft.description,
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Properties',
                style: sectionHeadingStyle,
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    height: 40,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: ColorPalette.dReaderBlue,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${formatPrice(nft.royalties)}%',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: ColorPalette.dReaderBlue,
                                  ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          'royalty',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  RoyaltyWidget(
                    isLarge: true,
                    iconPath: nft.isUsed
                        ? 'assets/icons/used_nft.svg'
                        : 'assets/icons/mint_icon.svg',
                    text: nft.isUsed ? 'Used' : 'Mint',
                    color: nft.isUsed
                        ? ColorPalette.lightblue
                        : ColorPalette.dReaderGreen,
                  ),
                  nft.isSigned
                      ? const RoyaltyWidget(
                          iconPath: 'assets/icons/signed_icon.svg',
                          text: 'Signed',
                          color: ColorPalette.dReaderOrange,
                          isLarge: true,
                        )
                      : const SizedBox(),
                  RarityWidget(
                    rarity: nft.rarity.rarityEnum,
                    iconPath: 'assets/icons/rarity.svg',
                    isLarge: true,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
          const Text(
            'Owner',
            style: sectionHeadingStyle,
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Text(
                formatAddress(nft.ownerAddress, 12),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                width: 8,
              ),
              GestureDetector(
                child: const Icon(
                  Icons.copy,
                  color: Colors.white,
                  size: 16,
                ),
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: nft.ownerAddress,
                    ),
                  ).then(
                    (value) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Owner address copied to clipboard",
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'NFT Address',
            style: sectionHeadingStyle,
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Text(
                formatAddress(nft.address, 12),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                width: 8,
              ),
              GestureDetector(
                child: const Icon(
                  Icons.copy,
                  color: Colors.white,
                  size: 16,
                ),
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: nft.address,
                    ),
                  ).then(
                    (value) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "NFT address copied to clipboard",
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          RoundedButton(
            text: 'View Issue Details',
            size: const Size(120, 50),
            borderColor: Colors.white,
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            onPressed: () {
              nextScreenPush(
                context,
                ComicIssueDetails(
                  id: nft.comicIssueId,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
