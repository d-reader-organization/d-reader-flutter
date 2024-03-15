import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HotIconSmall extends StatelessWidget {
  const HotIconSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: ColorPalette.dReaderRed,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            8,
          ),
          bottomRight: Radius.circular(
            8,
          ),
        ),
      ),
      child: SvgPicture.asset(
        'assets/icons/Hot.svg',
        width: 14,
        height: 14,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
