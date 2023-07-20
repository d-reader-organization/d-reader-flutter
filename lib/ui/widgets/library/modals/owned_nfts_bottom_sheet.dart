import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/models/owned_comic_issue.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/shorten_nft_name.dart';
import 'package:d_reader_flutter/ui/views/animations/open_nft_animation_screen.dart';
import 'package:d_reader_flutter/ui/views/nft_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/royalties/minted.dart';
import 'package:d_reader_flutter/ui/widgets/royalties/signed.dart';
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
            color: ColorPalette.boxBackground400,
          ),
          Expanded(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final ownedNft = ownedNfts[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
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
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  const MintedRoyalty(),
                                  ownedNft.isSigned
                                      ? const SignedRoyalty()
                                      : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        return Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: CustomTextButton(
                              borderColor: ColorPalette.dReaderGreen,
                              textColor: ColorPalette.dReaderGreen,
                              borderRadius: BorderRadius.circular(8),
                              padding: const EdgeInsets.only(
                                top: 4,
                                bottom: 4,
                                left: 4,
                              ),
                              backgroundColor: Colors.transparent,
                              onPressed: () async {
                                final isSuccessful = await ref
                                    .read(solanaProvider.notifier)
                                    .useMint(
                                      nftAddress: ownedNft.address,
                                    );
                                if (context.mounted && isSuccessful) {
                                  nextScreenPush(
                                    context,
                                    const OpenNftAnimation(),
                                  );
                                }
                              },
                              child: const Text('Open'),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 1,
                  color: ColorPalette.boxBackground400,
                );
              },
              itemCount: ownedNfts.length,
            ),
          ),
          const Divider(
            thickness: 1,
            color: ColorPalette.boxBackground400,
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(8),
                  textColor: const Color(0xFFEBEDF3),
                  borderColor: const Color(0xFFEBEDF3),
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
