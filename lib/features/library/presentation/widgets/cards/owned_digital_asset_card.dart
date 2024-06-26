import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/owned/owned_providers.dart';
import 'package:d_reader_flutter/features/digital_asset/domain/models/digital_asset.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/utils/extensions.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/utils/utils.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/rarity.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/royalty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OwnedDigitalAssetCard extends ConsumerWidget {
  final DigitalAssetModel digitalAsset;

  const OwnedDigitalAssetCard({
    super.key,
    required this.digitalAsset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.digitalAssetDetails}/${digitalAsset.address}',
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
            AspectRatio(
              aspectRatio: comicIssueAspectRatio,
              child: CachedImageBgPlaceholder(
                imageUrl: digitalAsset.image,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shortenDigitalAssetName(digitalAsset.name),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    runSpacing: 8,
                    children: [
                      digitalAsset.isUsed
                          ? const RoyaltyWidget(
                              iconPath: 'assets/icons/used_asset.svg',
                              text: 'Used',
                              color: ColorPalette.lightblue,
                            )
                          : const RoyaltyWidget(
                              iconPath: 'assets/icons/mint_icon.svg',
                              text: 'Mint',
                              color: ColorPalette.dReaderGreen,
                            ),
                      digitalAsset.isSigned
                          ? const RoyaltyWidget(
                              iconPath: 'assets/icons/signed_icon.svg',
                              text: 'Signed',
                              color: ColorPalette.dReaderOrange,
                            )
                          : const SizedBox(),
                      RarityWidget(
                        rarity: digitalAsset.rarity.rarityEnum,
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
