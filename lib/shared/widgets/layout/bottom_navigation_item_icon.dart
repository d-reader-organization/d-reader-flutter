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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset(
        imagePath,
        colorFilter: isActive
            ? const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              )
            : null,
      ),
    );
  }
}
