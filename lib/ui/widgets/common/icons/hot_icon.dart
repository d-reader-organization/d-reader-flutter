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
          // const Icon(
          //   Icons.local_fire_department_rounded,
          //   color: ColorPalette.appBackgroundColor,
          // ),
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
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        color: ColorPalette.dReaderYellow100,
        borderRadius: BorderRadius.circular(
          32,
        ),
      ),
      child: const Icon(
        Icons.local_fire_department_rounded,
        color: ColorPalette.appBackgroundColor,
        size: 18,
      ),
    );
  }
}
