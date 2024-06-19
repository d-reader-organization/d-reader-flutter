import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonRow extends StatelessWidget {
  final double height;
  final EdgeInsets margin;
  final BorderRadiusGeometry borderRadius;
  const SkeletonRow({
    super.key,
    this.height = 64,
    this.margin = const EdgeInsets.only(top: 8),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(8),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      shimmerDuration: 1000,
      borderRadius: borderRadius,
      shimmerColor: ColorPalette.greyscale100,
      child: Container(
        height: height,
        margin: margin,
      ),
    );
  }
}
