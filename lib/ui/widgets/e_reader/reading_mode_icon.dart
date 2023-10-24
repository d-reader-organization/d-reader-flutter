import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReadingModeIcon extends StatelessWidget {
  final bool isActive;
  final String iconPath;
  final Function() onTap;
  const ReadingModeIcon({
    super.key,
    required this.isActive,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(
          isActive ? Colors.white : ColorPalette.greyscale300,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
