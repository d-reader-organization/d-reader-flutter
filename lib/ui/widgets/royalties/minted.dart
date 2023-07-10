import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MintedRoyalty extends StatelessWidget {
  const MintedRoyalty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      height: 20,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: ColorPalette.dReaderGreen,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/mint_icon.svg',
            height: 10,
          ),
          const SizedBox(
            width: 4,
          ),
          const Text(
            'Mint',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
