import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/owned/owned_controller.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/features/nft/presentation/utils/extensions.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/features/nft/presentation/utils/utils.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/rarity.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/royalty.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OwnedNftsBottomSheet extends StatelessWidget {
  final List<NftModel> ownedNfts;
  final int episodeNumber;
  const OwnedNftsBottomSheet({
    super.key,
    required this.ownedNfts,
    required this.episodeNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: ColorPalette.greyscale400,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose to unwrap',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'By unwrapping the comic, you will be able to read it. This action is irreversible and will make the comic lose the mint condition.', //By unwrapping the comic, you will be able to read it. This action is irreversible and will make the comic lose the mint condition.
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 1,
            color: ColorPalette.greyscale300,
          ),
          Expanded(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final ownedNft = ownedNfts[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Episode $episodeNumber',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ColorPalette.greyscale100,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      shortenNftName(
                        ownedNft.name,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            runSpacing: 8,
                            children: [
                              RoyaltyWidget(
                                iconPath: ownedNft.isUsed
                                    ? 'assets/icons/used_nft.svg'
                                    : 'assets/icons/mint_icon.svg',
                                text: ownedNft.isUsed ? 'Used' : 'Mint',
                                color: ownedNft.isUsed
                                    ? ColorPalette.lightblue
                                    : ColorPalette.dReaderGreen,
                              ),
                              ownedNft.isSigned
                                  ? const RoyaltyWidget(
                                      iconPath: 'assets/icons/signed_icon.svg',
                                      text: 'Signed',
                                      color: ColorPalette.dReaderOrange,
                                    )
                                  : const SizedBox(),
                              RarityWidget(
                                rarity: ownedNft.rarity.rarityEnum,
                                iconPath: 'assets/icons/rarity.svg',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Consumer(
                            builder: (context, ref, child) {
                              return GestureDetector(
                                onTap: () async {
                                  try {
                                    await ref
                                        .read(ownedControllerProvider.notifier)
                                        .handleOpenNft(
                                          ownedNft: ownedNft,
                                          onSuccess: () {
                                            context.pop();
                                            return nextScreenPush(
                                              context: context,
                                              path: RoutePath.openNftAnimation,
                                            );
                                          },
                                          onFail: (message) {
                                            showSnackBar(
                                              context: context,
                                              backgroundColor:
                                                  ColorPalette.dReaderRed,
                                              text: message,
                                            );
                                          },
                                        );
                                  } catch (exception) {
                                    if (context.mounted) {
                                      context.pop();
                                      return triggerLowPowerOrNoWallet(
                                        context,
                                        exception,
                                      );
                                    }
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(
                                      minWidth: 80,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorPalette.dReaderGreen,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      ),
                                    ),
                                    child: const Text(
                                      'Open',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: ColorPalette.dReaderGreen,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 1,
                  color: ColorPalette.greyscale300,
                );
              },
              itemCount: ownedNfts.length,
            ),
          ),
          const Divider(
            thickness: 1,
            color: ColorPalette.greyscale300,
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextButton(
                  onPressed: () {
                    context.pop();
                  },
                  borderRadius: BorderRadius.circular(8),
                  textColor: ColorPalette.greyscale50,
                  borderColor: ColorPalette.greyscale50,
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                    right: 4,
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              Expanded(
                child: CustomTextButton(
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor: ColorPalette.dReaderGreen,
                  textColor: Colors.black,
                  onPressed: () {
                    nextScreenPush(
                      context: context,
                      path:
                          '${RoutePath.nftDetails}/${ownedNfts.first.address}',
                    );
                  },
                  padding: const EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                    left: 4,
                  ),
                  child: const Text('Auto pick'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
