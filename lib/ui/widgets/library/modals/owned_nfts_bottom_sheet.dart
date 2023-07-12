import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/models/owned_comic_issue.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/shorten_nft_name.dart';
import 'package:d_reader_flutter/ui/views/nft_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/royalties/minted.dart';
import 'package:d_reader_flutter/ui/widgets/royalties/signed.dart';
import 'package:flutter/material.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Choose to open'),
        const Text(
          'In order to read comic issue you need to open it from its package. read more',
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final ownedNft = ownedNfts[index];
            return Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Episode ${ownedIssue.number}',
                      ),
                      Text(
                        shortenNftName(
                          ownedNft.name,
                        ),
                      ),
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
                ),
                Expanded(
                  child: Column(
                    children: [
                      CustomTextButton(
                        borderColor: ColorPalette.dReaderGreen,
                        textColor: ColorPalette.dReaderGreen,
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          nextScreenPush(
                            context,
                            const NftDetails(
                              address: 'adsadsad',
                            ),
                          );
                        },
                        child: const Text('Open'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              thickness: 1,
              color: ColorPalette.boxBackground200,
            );
          },
          itemCount: ownedNfts.length,
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextButton(
                onPressed: () {},
                textColor: const Color(0xFFEBEDF3),
                borderColor: const Color(0xFFEBEDF3),
                backgroundColor: Colors.transparent,
                child: const Text('Cancel'),
              ),
            ),
            Expanded(
              child: CustomTextButton(
                backgroundColor: ColorPalette.dReaderGreen,
                textColor: Colors.black,
                onPressed: () {},
                child: const Text('Auto pick'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
