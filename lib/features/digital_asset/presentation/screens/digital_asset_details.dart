import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/owned_issues_notifier.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/widgets/button.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/owned/owned_providers.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/providers/digital_asset_controller.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/providers/digital_asset_providers.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/utils/extensions.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_transactions_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_wallet_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/utils/utils.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/widgets/digital_asset_card.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/unwrap_button.dart';
import 'package:d_reader_flutter/shared/widgets/cards/skeleton_card.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/carrot_error_widget.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/rarity.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/royalty.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/skeleton_row.dart';
import 'package:d_reader_flutter/shared/widgets/texts/text_with_view_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const sectionHeadingStyle = TextStyle(
  color: ColorPalette.greyscale200,
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

class DigitalAssetDetails extends ConsumerWidget {
  final String address;
  const DigitalAssetDetails({
    super.key,
    required this.address,
  });

  _handleDigitalAssetOpen({
    required BuildContext context,
    required WidgetRef ref,
    required String openResponse,
  }) {
    if (openResponse != successResult) {
      return showSnackBar(
        context: context,
        backgroundColor: ColorPalette.dReaderRed,
        text: openResponse,
      );
    }
    ref.invalidate(lastProcessedAssetProvider);
    ref.invalidate(digitalAssetsProvider);
    ref.invalidate(digitalAssetProvider);
    ref.invalidate(ownedComicsProvider);
    ref.invalidate(ownedIssuesAsyncProvider);
    ref.invalidate(comicIssuePagesProvider);
    ref.invalidate(comicIssueDetailsProvider);
    showSnackBar(
      context: context,
      text: 'Comic unwrapped successfully',
      backgroundColor: ColorPalette.dReaderGreen,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(digitalAssetProvider(address));
    final textTheme = Theme.of(context).textTheme;
    return provider.when(
      data: (digitalAsset) {
        if (digitalAsset == null) {
          return const Text('Something went wrong.');
        }
        return Scaffold(
          backgroundColor: ColorPalette.appBackgroundColor,
          body: RefreshIndicator(
            backgroundColor: ColorPalette.dReaderYellow100,
            color: ColorPalette.appBackgroundColor,
            onRefresh: () async {
              ref.invalidate(digitalAssetProvider);
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  title: Text(
                    shortenDigitalAssetName(digitalAsset.name),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  sliver: SliverToBoxAdapter(
                    child: DigitalAssetCard(
                      comicName: digitalAsset.comicName,
                      imageUrl: digitalAsset.image,
                      issueName: digitalAsset.comicIssueName,
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
                              child: ListOrDelistButton(
                                digitalAsset: digitalAsset,
                                isListButton: !digitalAsset.isListed,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: digitalAsset.isUsed
                                  ? ReadButton(digitalAsset: digitalAsset)
                                  : UnwrapButton(
                                      digitalAsset: digitalAsset,
                                      onPressed: () async {
                                        ref.read(selectedWalletProvider) ==
                                                ref
                                                    .read(
                                                        localWalletNotifierProvider)
                                                    .value
                                                    ?.address
                                            ? await ref
                                                .read(
                                                    localTransactionsNotifierProvider
                                                        .notifier)
                                                .handleUnwrap(
                                                  assetAddress:
                                                      digitalAsset.address,
                                                  ownerAddress:
                                                      digitalAsset.ownerAddress,
                                                )
                                            : await ref
                                                .read(
                                                    digitalAssetControllerProvider
                                                        .notifier)
                                                .openDigitalAsset(
                                                  digitalAsset: digitalAsset,
                                                  onOpen: (String result) {
                                                    _handleDigitalAssetOpen(
                                                      context: context,
                                                      ref: ref,
                                                      openResponse: result,
                                                    );
                                                  },
                                                  onException: (exception) {
                                                    if (exception
                                                            is LowPowerModeException ||
                                                        exception
                                                            is NoWalletFoundException) {
                                                      triggerLowPowerOrNoWallet(
                                                        context,
                                                        exception,
                                                      );
                                                      return;
                                                    } else if (exception
                                                        is AppException) {
                                                      showSnackBar(
                                                        context: context,
                                                        text: exception.message,
                                                      );
                                                    }
                                                  },
                                                );
                                      },
                                      borderColor:
                                          ColorPalette.dReaderYellow100,
                                      isLoading: ref
                                          .watch(globalNotifierProvider)
                                          .isLoading,
                                      backgroundColor: Colors.transparent,
                                      loadingColor:
                                          ColorPalette.dReaderYellow100,
                                      textColor: ColorPalette.dReaderYellow100,
                                      size: Size(
                                        MediaQuery.sizeOf(context).width / 2.4,
                                        40,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
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
                          text: digitalAsset.description,
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
                            Wrap(
                              runSpacing: 8,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
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
                                            '${Formatter.formatPrice(digitalAsset.royalties)}%',
                                            style:
                                                textTheme.bodySmall?.copyWith(
                                              color: ColorPalette.dReaderBlue,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            'royalty',
                                            style: textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                RoyaltyWidget(
                                  isLarge: true,
                                  iconPath: digitalAsset.isUsed
                                      ? 'assets/icons/used_asset.svg'
                                      : 'assets/icons/mint_icon.svg',
                                  text: digitalAsset.isUsed ? 'Used' : 'Mint',
                                  color: digitalAsset.isUsed
                                      ? ColorPalette.lightblue
                                      : ColorPalette.dReaderGreen,
                                ),
                                digitalAsset.isSigned
                                    ? const RoyaltyWidget(
                                        iconPath:
                                            'assets/icons/signed_icon.svg',
                                        text: 'Signed',
                                        color: ColorPalette.dReaderOrange,
                                        isLarge: true,
                                      )
                                    : const SizedBox(),
                                RarityWidget(
                                  rarity: digitalAsset.rarity.rarityEnum,
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
                              Formatter.formatAddress(
                                  digitalAsset.ownerAddress, 12),
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
                                    text: digitalAsset.ownerAddress,
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
                          'Token Address',
                          style: sectionHeadingStyle,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Text(
                              Formatter.formatAddress(digitalAsset.address, 12),
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
                                    text: digitalAsset.address,
                                  ),
                                ).then(
                                  (value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Token address copied to clipboard",
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
                                  '${RoutePath.comicIssueDetails}/${digitalAsset.comicIssueId}',
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
        return const CarrotErrorWidget(
          mainErrorText: 'We ran into some issues',
          adviceText: 'We are working on a fix. Thanks for your patience!',
        );
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
