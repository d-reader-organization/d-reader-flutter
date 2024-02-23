import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/providers/library/selected_owned_comic_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/image_widgets/cached_image_bg_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OwnedComicCard extends ConsumerWidget {
  final double cardWidth;
  final ComicModel comic;

  const OwnedComicCard({
    super.key,
    required this.cardWidth,
    required this.comic,
  });

  @override
  Widget build(BuildContext context, ref) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        ref.read(selectedOwnedComicProvider.notifier).update((state) => comic);
      },
      child: Container(
        width: cardWidth,
        constraints: const BoxConstraints(maxWidth: 190),
        decoration: BoxDecoration(
          color: ColorPalette.greyscale500,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImageBgPlaceholder(
              height: 125,
              imageUrl: comic.cover,
              width: cardWidth,
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
            Expanded(
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
