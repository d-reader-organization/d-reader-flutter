import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:flutter/material.dart';

class CommonCachedImage extends StatelessWidget {
  final String imageUrl;
  final String? cacheKey;
  final BoxFit fit;
  final Widget? placeholder;
  final Function()? onError;
  final double? height, width, cacheHeight, cacheWidth;

  const CommonCachedImage({
    super.key,
    required this.imageUrl,
    this.cacheKey,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.onError,
    this.height,
    this.width,
    this.cacheHeight,
    this.cacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      height: height,
      width: width,
      memCacheHeight: height?.cacheSize(context),
      memCacheWidth: width?.cacheSize(context),
      placeholder: (context, url) =>
          placeholder ??
          Container(
            height: 350,
            width: 350,
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
