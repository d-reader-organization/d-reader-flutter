import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:flutter/material.dart';

class CreatorAvatar extends StatelessWidget {
  final String avatar;
  final double radius;
  final String slug;
  final double? height;
  final double? width;
  const CreatorAvatar({
    super.key,
    required this.avatar,
    required this.slug,
    this.radius = 64,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CachedImageBgPlaceholder(
      imageUrl: avatar,
      borderRadius: radius,
      height: height,
      width: width,
    );
  }
}
