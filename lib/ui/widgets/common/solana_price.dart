import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:flutter/material.dart';

class SolanaPrice extends StatelessWidget {
  final double? price;
  final MainAxisAlignment mainAxisAlignment;
  final TextDirection? textDirection;
  final Color? textColor;
  const SolanaPrice({
    Key? key,
    this.price,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.textDirection,
    this.textColor,
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
          price != null ? formatPrice(price ?? 0) : 'Free',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
        ),
      ],
    );
  }
}
