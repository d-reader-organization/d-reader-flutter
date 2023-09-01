import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class InfoButton extends StatelessWidget {
  final bool isLoading;
  final Function() onTap;
  const InfoButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorPalette.greyscale100,
          ),
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: const Text(
          'Info',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
