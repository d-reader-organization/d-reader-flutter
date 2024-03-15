import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonRow extends StatelessWidget {
  const SkeletonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      shimmerDuration: 1000,
      child: Container(
        height: 64,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: ColorPalette.dReaderGrey,
          borderRadius: BorderRadius.circular(
            16,
          ),
        ),
      ),
    );
  }
}
