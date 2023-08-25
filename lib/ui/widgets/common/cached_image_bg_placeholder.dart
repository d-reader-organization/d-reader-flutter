import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CachedImageBgPlaceholder extends StatelessWidget {
  final String imageUrl;
  final Widget? child, placeholder;
  final double? height, width;
  final double borderRadius, opacity;
  final Decoration? foregroundDecoration;
  final BorderRadiusGeometry? overrideBorderRadius;
  final BoxFit bgImageFit;

  const CachedImageBgPlaceholder({
    Key? key,
    required this.imageUrl,
    this.child,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.foregroundDecoration,
    this.overrideBorderRadius,
    this.bgImageFit = BoxFit.cover,
    this.opacity = 1,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      key: ValueKey(imageUrl),
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        foregroundDecoration: foregroundDecoration,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: bgImageFit,
            opacity: opacity,
          ),
          borderRadius:
              overrideBorderRadius ?? BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
      placeholder: (context, url) =>
          placeholder ??
          Container(
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
        Sentry.captureException(error);
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
