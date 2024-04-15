import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigationItemIcon extends StatelessWidget {
  final String imagePath;
  final bool isActive;
  const BottomNavigationItemIcon({
    super.key,
    required this.imagePath,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imagePath,
      colorFilter: isActive
          ? const ColorFilter.mode(
              ColorPalette.dReaderYellow100,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
