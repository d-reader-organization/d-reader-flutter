import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/shorten_nft_name.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/buy_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/nft_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_with_view_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const sectionHeadingStyle = TextStyle(
  color: Color(0xFF777D8C),
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

class NftDetails extends StatelessWidget {
  final NftModel nft;
  const NftDetails({
    super.key,
    required this.nft,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          shortenNftName(nft.name),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: ColorPalette.appBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, top: 8.0),
        child: ListView(
          children: [
            NfTCard(
              comicName: nft.comicName,
              imageUrl: nft.image,
              issueName: nft.comicIssueName,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BuyButton(
                  backgroundColor: ColorPalette.dReaderGreen,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      8,
                    ),
                  ),
                  size: Size(MediaQuery.of(context).size.width / 2.4, 50),
                  child: Row(
                    children: const [
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
                  onPressed: () {},
                ),
                BuyButton(
                  size: Size(MediaQuery.of(context).size.width / 2.4, 50),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      8,
                    ),
                  ),
                  child: const Text('List'),
                  onPressed: () {},
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
            const TextWithViewMore(
              text:
                  'Fearless siblings come across a red hawk that has been injured. They work together to help nurse the hawk',
            ),
            const SizedBox(
              height: 8,
            ),
            nft.isMintCondition || nft.isSigned
                ? Column(
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
                          nft.isMintCondition
                              ? Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: ColorPalette.dReaderGreen,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/images/mint_icon.svg'),
                                      Text(
                                        'Mint',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          nft.isSigned
                              ? Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: ColorPalette.dReaderOrange,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/images/signed_icon.svg'),
                                      Text(
                                        'Signed',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  )
                : const SizedBox(),
            const Text(
              'Owner',
              style: sectionHeadingStyle,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              nft.owner,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'NFT Address',
              style: sectionHeadingStyle,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              nft.address,
              style: Theme.of(context).textTheme.bodyMedium,
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
