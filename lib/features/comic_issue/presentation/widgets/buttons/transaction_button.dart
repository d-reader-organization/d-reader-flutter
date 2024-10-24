import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/mint_price_widget.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransactionButton extends ConsumerWidget {
  final bool isListing, isLoading, isMultiGroup, isDisabled;
  final Function()? onPressed;
  final String text;
  final int? price;

  const TransactionButton({
    super.key,
    required this.isLoading,
    this.onPressed,
    required this.text,
    this.price,
    this.isListing = false,
    this.isMultiGroup = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context, ref) {
    return CustomTextButton(
      size: const Size(150, 50),
      isLoading: isLoading,
      fontSize: 16,
      isDisabled: isDisabled,
      borderRadius: const BorderRadius.all(
        Radius.circular(
          8,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.black,
                ),
          ),
          const SizedBox(
            width: 4,
          ),
          isListing && price == null
              ? Image.asset(
                  Config.solanaLogoPath,
                  width: 14,
                  height: 10,
                )
              : isMultiGroup
                  ? const MintPriceWidget(
                      priceColor: Colors.black,
                    )
                  : PriceWidget(
                      price: price != null && price! > 0
                          ? Formatter.formatPriceByCurrency(
                              mintPrice: price!,
                              splToken: ref.watch(
                                activeSplToken,
                              ),
                            )
                          : null,
                      textColor: Colors.black,
                    ),
        ],
      ),
    );
  }
}
