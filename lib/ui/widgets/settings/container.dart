import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsContainer extends StatelessWidget {
  final Widget leftWidget;
  final Widget? rightWidget;
  final VoidCallback? onPressed;
  const SettingsContainer({
    super.key,
    required this.leftWidget,
    this.onPressed,
    this.rightWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: ColorPalette.boxBackground300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leftWidget,
            rightWidget ??
                Icon(
                  Icons.arrow_right,
                  color: onPressed == null ? Colors.grey : Colors.white,
                ),
          ],
        ),
      ),
    );
  }
}
