import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class FilledIcon extends StatelessWidget {
  final IconData iconData;
  final Color backgroundColor;
  const FilledIcon({
    Key? key,
    required this.iconData,
    this.backgroundColor = ColorPalette.boxBackground300,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: ColorPalette.boxBackground300,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        iconData,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
