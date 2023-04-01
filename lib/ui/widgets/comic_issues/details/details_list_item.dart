import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/listing_item.dart';
import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/core/providers/auction_house_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:d_reader_flutter/ui/utils/shorten_nft_name.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as fcm;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solana/solana.dart' show lamportsPerSol;
import 'package:timeago/timeago.dart' as timeago;

class ReceiptListItem extends StatelessWidget {
  final Receipt receipt;
  const ReceiptListItem({
    super.key,
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        maxRadius: 24,
        backgroundImage: receipt.buyer.avatar.isNotEmpty
            ? CachedNetworkImageProvider(
                receipt.buyer.avatar,
                cacheKey: receipt.buyer.address,
                cacheManager: fcm.CacheManager(
                  fcm.Config(
                    receipt.buyer.address,
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
              receipt.buyer.label.isNotEmpty
                  ? receipt.buyer.label
                  : formatAddress(receipt.buyer.address),
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
                      shortenNftName(receipt.nft.name),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      timeago.format(
                        DateTime.parse(
                          receipt.timestamp,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.dReaderGreen,
                      ),
                    ),
                  ],
                ),
                SolanaPrice(
                  price: receipt.price / lamportsPerSol,
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

class ListingItemRow extends ConsumerWidget {
  final ListingItemModel listing;
  const ListingItemRow({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(selectedItemsProvider);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      selected: selectedItems.contains(listing),
      selectedColor: ColorPalette.dReaderYellow100,
      selectedTileColor: ColorPalette.boxBackground300,
      splashColor: Colors.transparent,
      onTap: () {
        final items = [...selectedItems];
        if (selectedItems.contains(listing)) {
          items.remove(listing);
        } else {
          items.add(listing);
        }
        ref.read(selectedItemsProvider.notifier).state = items;
      },
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
              '${formatAddress(listing.seller.address)} ${formatWalletLabel(listing.seller.label)}',
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
