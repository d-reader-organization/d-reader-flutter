import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/shorten_nft_name.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:flutter/material.dart';
import 'package:solana/solana.dart' show lamportsPerSol;
import 'package:timeago/timeago.dart' as timeago;

class MintedItemRow extends StatelessWidget {
  final Receipt receipt;
  const MintedItemRow({
    super.key,
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = receipt.buyer.avatar ?? '';
    final buyerName = receipt.buyer.name ?? '';
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      leading: CircleAvatar(
        maxRadius: 24,
        backgroundColor: ColorPalette.greyscale500,
        backgroundImage: avatar.isNotEmpty
            ? CachedNetworkImageProvider(
                avatar,
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
              buyerName,
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
