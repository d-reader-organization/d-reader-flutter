import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommonCachedImage extends StatelessWidget {
  final String imageUrl;
  final String? slug;
  final BoxFit fit;
  const CommonCachedImage({
    Key? key,
    required this.imageUrl,
    this.slug,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (context, url) => Container(
        height: 200,
        width: 200,
        color: Colors.grey,
      ),
      errorWidget: (context, url, error) => Container(
        height: 200,
        width: 200,
        color: Colors.red,
      ),
      cacheKey: slug,
    );
  }
}
