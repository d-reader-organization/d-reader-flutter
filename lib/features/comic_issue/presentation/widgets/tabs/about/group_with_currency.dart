import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine_coupon.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/notifiers/candy_machine_notifier.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/features/settings/domain/models/spl_token.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CouponWithCurrencyRow extends ConsumerWidget {
  final SplToken splToken;
  final int mintPrice;
  final List<CouponCurrencySetting> prices;
  const CouponWithCurrencyRow({
    super.key,
    required this.splToken,
    required this.mintPrice,
    required this.prices,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final bool isSelected = ref
            .watch(candyMachineNotifierProvider)
            .selectedCurrency
            ?.splTokenAddress ==
        splToken.address;
    return GestureDetector(
      onTap: () {
        final selectedCurrency = prices
            .firstWhere((price) => price.splTokenAddress == splToken.address);
        ref
            .read(candyMachineNotifierProvider.notifier)
            .updateSelectedCurrency(selectedCurrency);
        ref.read(activeSplToken.notifier).update((state) => splToken);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected
                  ? ColorPalette.dReaderYellow100
                  : ColorPalette.greyscale300),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? const Color.fromARGB(255, 103, 96, 34).withOpacity(.1)
              : ColorPalette.appBackgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: splToken.icon,
                  width: 16,
                  height: 16,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  splToken.symbol.replaceFirst(
                    '\$',
                    '',
                  ),
                  style: textTheme.bodySmall,
                ),
              ],
            ),
            Text(
              Formatter.formatPriceByCurrency(
                mintPrice: mintPrice,
                splToken: splToken,
              ),
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
