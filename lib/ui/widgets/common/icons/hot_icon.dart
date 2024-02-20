import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HotIcon extends StatelessWidget {
  const HotIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: ColorPalette.dReaderYellow100,
        borderRadius: BorderRadius.circular(
          32,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/Hot.svg',
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            ),
            width: 20,
            height: 20,
          ),
          Text(
            'HOT',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: ColorPalette.appBackgroundColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class HotIconSmall extends StatelessWidget {
  const HotIconSmall({Key? key}) : super(key: key);

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
