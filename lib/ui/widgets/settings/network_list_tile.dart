import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class NetworkListTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function()? onTap;
  const NetworkListTile({
    super.key,
    required this.title,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      splashColor: onTap != null ? ColorPalette.greyscale400 : null,
      selected: isSelected,
      tileColor: ColorPalette.greyscale400,
      iconColor: onTap == null ? ColorPalette.greyscale300 : Colors.white,
      textColor: onTap == null ? ColorPalette.greyscale300 : Colors.white,
      selectedColor: ColorPalette.dReaderYellow100,
      selectedTileColor: ColorPalette.greyscale400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          8,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      leading: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: const Icon(
        Icons.check_circle,
      ),
    );
  }
}
