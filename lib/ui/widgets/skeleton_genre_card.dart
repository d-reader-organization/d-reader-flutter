import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonGenreCard extends StatelessWidget {
  const SkeletonGenreCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      shimmerDuration: 500,
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        height: 90,
        width: 85,
        decoration: BoxDecoration(
          color: dReaderGrey,
          borderRadius: BorderRadius.circular(
            5,
          ),
        ),
      ),
    );
  }
}
