import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ButtonWithIcon extends ConsumerWidget {
  final String name;
  final Widget label;
  final Widget icon;
  final Function()? onPressed;
  final Color selectedColor;
  final bool isSelected;
  const ButtonWithIcon({
    super.key,
    required this.name,
    required this.label,
    required this.icon,
    this.onPressed,
    required this.selectedColor,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? Colors.black : Colors.white,
        backgroundColor: isSelected ? selectedColor : null,
        fixedSize: const Size(double.infinity, 50),
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
          side: const BorderSide(
            color: ColorPalette.boxBackground400,
          ),
        ),
      ),
      onPressed: onPressed,
      icon: icon,
      label: label,
    );
  }
}
