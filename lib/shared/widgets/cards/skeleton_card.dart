import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonCard extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsets? margin;
  final bool withBorderRadius;
  final LinearGradient gradient;

  const SkeletonCard({
    super.key,
    this.height = 255,
    this.width = 180,
    this.margin,
    this.withBorderRadius = true,
    this.gradient = const LinearGradient(
      colors: [
        ColorPalette.greyscale500,
        Colors.transparent,
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: [0, 0.8],
    ),
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      shimmerDuration: 1000,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: ColorPalette.dReaderGrey,
          borderRadius: withBorderRadius
              ? BorderRadius.circular(
                  8,
                )
              : null,
        ),
        foregroundDecoration: BoxDecoration(
          gradient: gradient,
        ),
      ),
    );
  }
}
