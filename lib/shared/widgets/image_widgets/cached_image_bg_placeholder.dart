import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// ShaderMask(
//             shaderCallback: (rect) {
//               return const LinearGradient(
//                 colors: [
//                   ColorPalette.appBackgroundColor,
//                   Color.fromRGBO(31, 34, 42, 0.0),
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 stops: [0.5579, 1],
//               ).createShader(rect);
//             },
//             blendMode: BlendMode.dstIn,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius:
//                     overrideBorderRadius ?? BorderRadius.circular(borderRadius),
//               ),
//               child: CachedNetworkImage(
//                 imageUrl: imageUrl,
//                 memCacheHeight: cacheHeight,
//                 memCacheWidth: cacheWidth,
//                 fit: bgImageFit,
//                 placeholder: (context, url) =>
//                     placeholder ??
//                     Container(
//                       height: height,
//                       width: width,
//                       decoration: BoxDecoration(
//                         color: Colors.grey,
//                         borderRadius: overrideBorderRadius ??
//                             BorderRadius.circular(borderRadius),
//                       ),
//                       foregroundDecoration: foregroundDecoration,
//                     ),
//                 errorWidget: (context, url, error) {
//                   Sentry.captureException(error,
//                       stackTrace: 'Cached image bg placeholder.');
//                   if (onError != null) {
//                     onError!();
//                   }
//                   return Container(
//                     height: height,
//                     width: width,
//                     decoration: BoxDecoration(
//                       color: ColorPalette.greyscale400,
//                       borderRadius: overrideBorderRadius ??
//                           BorderRadius.circular(borderRadius),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           )

extension ImageExtension on num {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }
}

class CachedImageBgPlaceholder extends StatelessWidget {
  final String imageUrl;
  final Widget? child, placeholder;
  final double? height, width;
  final int? cacheWidth, cacheHeight;
  final double borderRadius, opacity;
  final Decoration? foregroundDecoration;
  final BorderRadiusGeometry? overrideBorderRadius;
  final BoxFit bgImageFit;
  final EdgeInsetsGeometry padding;
  final Function()? onError;

  const CachedImageBgPlaceholder({
    super.key,
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
    this.padding = const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    this.onError,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      memCacheHeight: cacheHeight,
      memCacheWidth: cacheWidth,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        padding: padding,
        foregroundDecoration: foregroundDecoration,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              imageUrl,
              maxHeight: cacheHeight,
              maxWidth: cacheWidth,
            ),
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
        Sentry.captureException(error,
            stackTrace: 'Cached image bg placeholder.');
        if (onError != null) {
          onError!();
        }
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: ColorPalette.greyscale400,
            borderRadius:
                overrideBorderRadius ?? BorderRadius.circular(borderRadius),
          ),
        );
      },
    );
  }
}
