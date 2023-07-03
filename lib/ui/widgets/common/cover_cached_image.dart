import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommonCachedImage extends StatelessWidget {
  final String imageUrl;
  final String? cacheKey;
  final BoxFit fit;
  final Widget? placeholder;
  const CommonCachedImage({
    Key? key,
    required this.imageUrl,
    this.cacheKey,
    this.fit = BoxFit.cover,
    this.placeholder,
  }) : super(key: key);

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
            color: Colors.grey,
          ),
      errorWidget: (context, url, error) => Container(
        height: 200,
        width: 200,
        color: Colors.red,
      ),
    );
  }
}
