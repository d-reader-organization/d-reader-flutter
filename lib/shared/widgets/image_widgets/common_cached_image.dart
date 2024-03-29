import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CommonCachedImage extends StatelessWidget {
  final String imageUrl;
  final String? cacheKey;
  final BoxFit fit;
  final Widget? placeholder;
  final Function()? onError;

  const CommonCachedImage({
    super.key,
    required this.imageUrl,
    this.cacheKey,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ??
          Container(
            height: 200,
            width: 200,
            color: ColorPalette.greyscale400,
          ),
      errorWidget: (context, url, error) {
        if (onError != null) {
          onError!();
        }
        return Container(
          height: 400,
          width: 400,
          color: ColorPalette.greyscale400,
        );
      },
    );
  }
}
