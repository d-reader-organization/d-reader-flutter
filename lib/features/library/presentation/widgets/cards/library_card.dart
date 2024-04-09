import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LibraryCard extends ConsumerWidget {
  final ComicModel comic;
  final void Function() onTap;
  const LibraryCard({
    super.key,
    required this.comic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, ref) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorPalette.greyscale500,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 9,
              child: AspectRatio(
                aspectRatio: comicAspectRatio,
                child: CachedImageBgPlaceholder(
                  imageUrl: comic.cover,
                  opacity: .4,
                  overrideBorderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: comic.logo.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: comic.logo,
                        )
                      : null,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comic.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      '${comic.stats?.issuesCount ?? 0} EP',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
