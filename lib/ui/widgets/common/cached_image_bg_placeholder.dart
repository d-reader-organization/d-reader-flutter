import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageBgPlaceholder extends StatelessWidget {
  final String imageUrl;
  final String cacheKey;
  final Widget? child;
  final double? width;
  final double? height;
  final double borderRadius;
  final Decoration? foregroundDecoration;
  final BorderRadiusGeometry? overrideBorderRadius;
  const CachedImageBgPlaceholder({
    Key? key,
    required this.imageUrl,
    required this.cacheKey,
    this.child,
    this.width,
    this.height,
    this.borderRadius = 16,
    this.foregroundDecoration,
    this.overrideBorderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheKey: cacheKey,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        foregroundDecoration: foregroundDecoration,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
          borderRadius:
              overrideBorderRadius ?? BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
      placeholder: (context, url) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius:
              overrideBorderRadius ?? BorderRadius.circular(borderRadius),
        ),
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
