import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BodyFilterAndSortContainer extends StatelessWidget {
  final Widget child;
  const BodyFilterAndSortContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 36,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: ColorPalette.greyscale500,
        border: Border.all(
          color: ColorPalette.greyscale300,
        ),
        borderRadius: BorderRadius.circular(
          8,
        ),
      ),
      child: child,
    );
  }
}
