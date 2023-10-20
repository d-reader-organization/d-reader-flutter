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
        constraints:
            const BoxConstraints(minWidth: 80, minHeight: 40, maxWidth: 80),
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
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: ColorPalette.greyscale100,
                  ),
                ),
              )
            : const Text(
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
