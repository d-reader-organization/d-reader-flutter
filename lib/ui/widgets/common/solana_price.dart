import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:flutter/material.dart';

class SolanaPrice extends StatelessWidget {
  final double? price;
  final MainAxisAlignment mainAxisAlignment;
  final TextDirection? textDirection;
  final Color? textColor;
  final int priceDecimals;
  const SolanaPrice({
    Key? key,
    this.price,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.textDirection,
    this.textColor,
    this.priceDecimals = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      textDirection: textDirection,
      children: [
        Image.asset(
          Config.solanaLogoPath,
          width: 14,
          height: 10,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          price != null && price != 0.0
              ? formatPrice(
                  price ?? 0,
                  priceDecimals,
                )
              : 'Free',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
        ),
      ],
    );
  }
}
