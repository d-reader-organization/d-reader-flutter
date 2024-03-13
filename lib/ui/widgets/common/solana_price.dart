import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/ui/utils/formatter.dart';
import 'package:flutter/material.dart';

class SolanaPrice extends StatelessWidget {
  final dynamic price;
  final MainAxisAlignment mainAxisAlignment;
  final TextDirection? textDirection;
  final Color? textColor;
  final int priceDecimals;
  const SolanaPrice({
    super.key,
    this.price,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.textDirection,
    this.textColor,
    this.priceDecimals = 2,
  });

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
          price != null && price is double && price != 0.0
              ? Formatter.formatPrice(
                  price ?? 0,
                  priceDecimals,
                )
              : price is String
                  ? price
                  : 'Free',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: textColor,
              ),
        ),
      ],
    );
  }
}
