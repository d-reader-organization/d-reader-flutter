import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/cover_cached_image.dart';
import 'package:flutter/material.dart';

class CreatorAvatar extends StatelessWidget {
  final String avatar;
  final double radius;
  final String slug;
  const CreatorAvatar({
    super.key,
    required this.avatar,
    required this.slug,
    this.radius = 64,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: ColorPalette.boxBackground300,
      child: CommonCachedImage(
        imageUrl: avatar,
        fit: BoxFit.scaleDown,
        cacheKey: slug,
      ),
    );
  }
}
