import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/owned_providers.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/features/nft/presentation/utils/extensions.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/features/nft/presentation/utils/utils.dart';
import 'package:d_reader_flutter/ui/widgets/common/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/rarity.dart';
import 'package:d_reader_flutter/ui/widgets/common/royalty.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OwnedNftCard extends ConsumerWidget {
  final NftModel nft;

  const OwnedNftCard({
    super.key,
    required this.nft,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.nftDetails}/${nft.address}',
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 130,
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 4,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: CachedImageBgPlaceholder(
                imageUrl: nft.image,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shortenNftName(nft.name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorPalette.greyscale100,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        ref.watch(selectedIssueInfoProvider)?.title ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      nft.isUsed
                          ? const RoyaltyWidget(
                              iconPath: 'assets/icons/used_nft.svg',
                              text: 'Used',
                              color: ColorPalette.lightblue,
                            )
                          : const RoyaltyWidget(
                              iconPath: 'assets/icons/mint_icon.svg',
                              text: 'Mint',
                              color: ColorPalette.dReaderGreen,
                            ),
                      nft.isSigned
                          ? const RoyaltyWidget(
                              iconPath: 'assets/icons/signed_icon.svg',
                              text: 'Signed',
                              color: ColorPalette.dReaderOrange,
                            )
                          : const SizedBox(),
                      RarityWidget(
                        rarity: nft.rarity.rarityEnum,
                        iconPath: 'assets/icons/rarity.svg',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
