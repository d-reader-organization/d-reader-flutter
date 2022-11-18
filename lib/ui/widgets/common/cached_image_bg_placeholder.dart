import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageBgPlaceholder extends StatelessWidget {
  final String imageUrl;
  final Widget child;
  final double? width;
  final double? height;
  const CachedImageBgPlaceholder({
    Key? key,
    required this.imageUrl,
    required this.child,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheKey: imageUrl,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
      placeholder: (context, url) => Container(
        height: height,
        width: width,
        color: Colors.grey,
      ),
      errorWidget: (context, url, error) {
        print(error);
        return Container(
          height: height,
          width: width,
          color: Colors.red,
        );
      },
    );
  }
}
