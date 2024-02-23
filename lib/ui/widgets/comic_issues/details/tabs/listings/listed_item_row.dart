import 'package:d_reader_flutter/core/models/listed_item.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/auction_house_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:d_reader_flutter/ui/utils/formatter.dart';
import 'package:d_reader_flutter/ui/utils/shorten_nft_name.dart';
import 'package:d_reader_flutter/ui/widgets/common/common_cached_image.dart';
import 'package:d_reader_flutter/ui/widgets/common/rarity.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solana/solana.dart' show lamportsPerSol;

class ListingItem extends ConsumerWidget {
  final ListingModel listing;
  const ListingItem({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final selectedItems = ref.watch(selectedItemsProvider);
    final myWallets = ref.watch(
      userWalletsProvider(
        id: ref.read(environmentProvider).user?.id,
      ),
    );
    final bool isSelected = selectedItems.contains(listing);
    return GestureDetector(
      onTap: myWallets.value != null &&
              myWallets.value!.isNotEmpty &&
              !myWallets.value!
                  .any((element) => element.address == listing.seller.address)
          ? () {
              List<ListingModel> items = [...selectedItems];
              if (selectedItems.contains(listing)) {
                items.remove(listing);
              } else {
                items.add(listing);
              }
              ref.read(selectedItemsProvider.notifier).state = items;
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorPalette.greyscale500
              : ColorPalette.appBackgroundColor,
          border: Border(
            left: BorderSide(
              width: 1.5,
              color: isSelected
                  ? ColorPalette.dReaderYellow100
                  : Colors.transparent,
            ),
            bottom: const BorderSide(
              width: 1,
              color: ColorPalette.greyscale400,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shortenNftName(listing.name),
                  style: textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    listing.seller.avatar != null &&
                            listing.seller.avatar!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: ColorPalette.greyscale500,
                              ),
                              child: CommonCachedImage(
                                imageUrl: listing.seller.avatar!,
                              ),
                            ),
                          )
                        : SvgPicture.asset(
                            'assets/icons/profile_bold.svg',
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      listing.seller.name != null &&
                              listing.seller.name!.isNotEmpty
                          ? listing.seller.name!
                          : Formatter.formatAddress(listing.seller.address, 4),
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SolanaPrice(
                  price: listing.price / lamportsPerSol,
                  priceDecimals: 4,
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    ConditionContainer(
                      borderColor: listing.isUsed
                          ? ColorPalette.lightblue
                          : ColorPalette.dReaderGreen,
                      icon: listing.isUsed
                          ? 'assets/icons/used_nft.svg'
                          : 'assets/icons/mint_icon.svg',
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    if (listing.isSigned) ...[
                      const ConditionContainer(
                        borderColor: ColorPalette.dReaderOrange,
                        icon: 'assets/icons/signed_icon.svg',
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                    ],
                    RarityWidget(
                      rarity: listing.rarity.rarityEnum,
                      iconPath: 'assets/icons/rarity.svg',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ConditionContainer extends StatelessWidget {
  final Color borderColor;
  final String icon;

  const ConditionContainer({
    super.key,
    required this.borderColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: SvgPicture.asset(
        icon,
        height: 16,
        width: 16,
      ),
    );
  }
}