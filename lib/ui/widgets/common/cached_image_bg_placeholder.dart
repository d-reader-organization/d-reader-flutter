import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedImageBgPlaceholder extends StatelessWidget {
  final String imageUrl;
  final String cacheKey;
  final Widget? child;
  final double? width;
  final double? height;
  final double borderRadius;
  final Decoration? foregroundDecoration;
  final BorderRadiusGeometry? overrideBorderRadius;
  final BoxFit bgImageFit;
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
    this.bgImageFit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheKey: cacheKey,
      cacheManager: CacheManager(
        Config(
          cacheKey,
          stalePeriod: const Duration(days: 1),
        ),
      ),
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        foregroundDecoration: foregroundDecoration,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: bgImageFit,
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
        foregroundDecoration: foregroundDecoration,
      ),
      errorWidget: (context, url, error) {
        print(error);
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: ColorPalette.dReaderRed,
            borderRadius:
                overrideBorderRadius ?? BorderRadius.circular(borderRadius),
          ),
        );
      },
    );
  }
}
