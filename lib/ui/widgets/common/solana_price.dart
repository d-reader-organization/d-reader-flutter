import 'package:d_reader_flutter/config/config.dart';
import 'package:flutter/material.dart';

class SolanaPrice extends StatelessWidget {
  final double? price;
  const SolanaPrice({Key? key, this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
          price?.toString() ?? 'Free',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
