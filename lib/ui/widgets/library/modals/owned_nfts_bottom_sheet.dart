import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/models/owned_comic_issue.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/shorten_nft_name.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/views/animations/open_nft_animation_screen.dart';
import 'package:d_reader_flutter/ui/views/nft_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/rarity.dart';
import 'package:d_reader_flutter/ui/widgets/common/royalty.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OwnedNftsBottomSheet extends StatelessWidget {
  final List<NftModel> ownedNfts;
  final OwnedComicIssue ownedIssue;
  const OwnedNftsBottomSheet({
    super.key,
    required this.ownedNfts,
    required this.ownedIssue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: ColorPalette.boxBackground300,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose to open',
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
                'In order to read comic issue you need to open it from its package.',
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
                      'Episode ${ownedIssue.number}',
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
                            runSpacing: 4,
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
                                  final isSuccessful = await ref
                                      .read(solanaProvider.notifier)
                                      .useMint(
                                        nftAddress: ownedNft.address,
                                        ownerAddress: ownedNft.ownerAddress,
                                      );
                                  if (context.mounted) {
                                    Navigator.pop(context);
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
                    Navigator.pop(context);
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
                      context,
                      NftDetails(
                        address: ownedNfts.first.address,
                      ),
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
