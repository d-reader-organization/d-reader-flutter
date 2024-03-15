import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/nft/presentations/providers/nft_controller.dart';
import 'package:d_reader_flutter/features/nft/presentations/providers/nft_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_providers.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:d_reader_flutter/ui/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/ui/utils/formatter.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/shorten_nft_name.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
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

const sectionHeadingStyle = TextStyle(
  color: ColorPalette.greyscale200,
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

class NftDetails extends ConsumerWidget {
  final String address;
  const NftDetails({
    super.key,
    required this.address,
  });

  _handleNftOpen(BuildContext context, String openResponse) {
    if (openResponse == 'OK') {
      return nextScreenPush(
        context: context,
        path: RoutePath.openNftAnimation,
      );
    }
    showSnackBar(
      context: context,
      backgroundColor: ColorPalette.dReaderRed,
      text: openResponse,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(nftProvider(address));
    final textTheme = Theme.of(context).textTheme;
    return provider.when(
      data: (nft) {
        if (nft == null) {
          return const Text('Something went wrong.');
        }
        return Scaffold(
          backgroundColor: ColorPalette.appBackgroundColor,
          body: RefreshIndicator(
            backgroundColor: ColorPalette.dReaderYellow100,
            color: ColorPalette.appBackgroundColor,
            onRefresh: () async {
              ref.invalidate(nftProvider);
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  title: Text(
                    shortenNftName(nft.name),
                    style: Theme.of(context).textTheme.headlineMedium,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const PageScrollPhysics(),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Button(
                                onPressed: () async {
                                  if (nft.isListed) {
                                    return await ref
                                        .read(nftControllerProvider.notifier)
                                        .delist(
                                          nftAddress: nft.address,
                                          callback: () {
                                            showSnackBar(
                                              context: context,
                                              text: 'Successfully delisted',
                                              backgroundColor:
                                                  ColorPalette.dReaderGreen,
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
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom:
                                              MediaQuery.viewInsetsOf(context)
                                                  .bottom,
                                        ),
                                        child: NftModalBottomSheet(nft: nft),
                                      );
                                    },
                                  );
                                },
                                child: nft.isListed
                                    ? Text(
                                        'Delist',
                                        style: textTheme.titleMedium?.copyWith(
                                          color: ColorPalette.greyscale200,
                                        ),
                                      )
                                    : Text(
                                        'List',
                                        style: textTheme.titleMedium?.copyWith(
                                          color: ColorPalette.greyscale200,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Button(
                                borderColor: ColorPalette.dReaderGreen,
                                child: Text(
                                  nft.isUsed ? 'Read' : 'Open',
                                  style: textTheme.titleMedium?.copyWith(
                                    color: ColorPalette.dReaderGreen,
                                  ),
                                ),
                                onPressed: () async {
                                  if (nft.isUsed) {
                                    return nextScreenPush(
                                      context: context,
                                      path:
                                          '${RoutePath.eReader}/${nft.comicIssueId}',
                                    );
                                  }
                                  await ref
                                      .read(nftControllerProvider.notifier)
                                      .openNft(
                                        nft: nft,
                                        onOpen: (String result) {
                                          _handleNftOpen(context, result);
                                        },
                                        onException: (exception) {
                                          triggerLowPowerOrNoWallet(
                                            context,
                                            exception,
                                          );
                                        },
                                      );
                                },
                              ),
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
                          height: 8,
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
                              height: 8,
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
                                        '${Formatter.formatPrice(nft.royalties)}%',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: ColorPalette.dReaderBlue,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'royalty',
                                        style: textTheme.bodyMedium,
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
                                        iconPath:
                                            'assets/icons/signed_icon.svg',
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
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              Formatter.formatAddress(nft.ownerAddress, 12),
                              style: textTheme.bodySmall,
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
                                  (value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(
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
                              Formatter.formatAddress(nft.address, 12),
                              style: textTheme.bodySmall,
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
                                  (value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(
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
                        CustomTextButton(
                          size: const Size(120, 50),
                          borderColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          backgroundColor: Colors.transparent,
                          textColor: Colors.white,
                          onPressed: () {
                            nextScreenPush(
                              context: context,
                              path:
                                  '${RoutePath.comicIssueDetails}/${nft.comicIssueId}',
                            );
                          },
                          child: Text(
                            'View Issue Details',
                            style: textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
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

class Button extends ConsumerWidget {
  final Widget child;
  final Future<void> Function() onPressed;
  final Color backgroundColor, borderColor;
  const Button({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor = Colors.transparent,
    this.borderColor = ColorPalette.greyscale200,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTextButton(
      size: Size(MediaQuery.sizeOf(context).width / 2.4, 40),
      borderRadius: const BorderRadius.all(
        Radius.circular(
          8,
        ),
      ),
      borderColor: borderColor,
      padding: const EdgeInsets.symmetric(vertical: 8),
      backgroundColor: backgroundColor,
      isLoading: ref.watch(globalNotifierProvider).isLoading,
      onPressed: ref.watch(isOpeningSessionProvider) ? null : onPressed,
      child: child,
    );
  }
}
