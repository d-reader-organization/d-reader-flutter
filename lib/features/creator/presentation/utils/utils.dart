import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:flutter/material.dart';

final RegExp unsupportedCacheTypesRegex = RegExp(r'\.gif$|\.webp$');

Widget renderAvatar({
  required BuildContext context,
  required CreatorModel creator,
  double height = 36,
  double width = 36,
}) {
  if (creator.avatar.isEmpty) {
    return const CircleAvatar(
      backgroundColor: ColorPalette.greyscale400,
    );
  }
  if (!unsupportedCacheTypesRegex.hasMatch(creator.avatar)) {
    return CircleAvatar(
      backgroundImage: CachedNetworkImageProvider(
        creator.avatar,
        maxHeight: height.cacheSize(context),
        maxWidth: width.cacheSize(context),
      ),
    );
  }
  // issue with caching gif
  final int? cacheValue =
      creator.avatar.contains('.gif') ? null : height.toInt();

  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(64),
      image: DecorationImage(
        image: CachedNetworkImageProvider(
          creator.avatar,
          maxHeight: cacheValue?.cacheSize(context),
          maxWidth: cacheValue?.cacheSize(context),
        ),
      ),
    ),
  );
}
