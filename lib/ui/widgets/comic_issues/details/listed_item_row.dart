import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/listed_item.dart';
import 'package:d_reader_flutter/core/providers/auction_house_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:d_reader_flutter/ui/utils/shorten_nft_name.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as fcm;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solana/solana.dart' show lamportsPerSol;

class ListedItemRow extends ConsumerWidget {
  final ListingModel listing;
  const ListedItemRow({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(selectedItemsProvider);
    final myWallet = ref.watch(myWalletProvider);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      selected: selectedItems.contains(listing),
      selectedColor: ColorPalette.dReaderYellow100,
      selectedTileColor: ColorPalette.boxBackground300,
      splashColor: Colors.transparent,
      onTap: myWallet.value?.address != listing.seller.address
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
      leading: CircleAvatar(
        maxRadius: 24,
        backgroundImage: listing.seller.avatar.isNotEmpty
            ? CachedNetworkImageProvider(
                listing.seller.avatar,
                cacheKey: listing.seller.address,
                cacheManager: fcm.CacheManager(
                  fcm.Config(
                    listing.seller.address,
                    stalePeriod: const Duration(days: 1),
                  ),
                ),
              )
            : null,
      ),
      title: SizedBox(
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${formatAddress(listing.seller.address, 4)} ${formatWalletName(listing.seller.name)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      shortenNftName(listing.name),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Row(
                      children: [
                        !listing.isUsed
                            ? SvgPicture.asset(
                                'assets/icons/mint_issue.svg',
                              )
                            : const SizedBox(),
                        listing.isSigned
                            ? SvgPicture.asset(
                                'assets/icons/signed_issue.svg',
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ],
                ),
                SolanaPrice(
                  price: listing.price / lamportsPerSol,
                  priceDecimals: 4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
