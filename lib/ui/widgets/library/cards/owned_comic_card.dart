import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/library/owned_issues_items.dart';
import 'package:flutter/material.dart';

class OwnedComicCard extends StatelessWidget {
  final double cardWidth;
  final ComicModel comic;

  const OwnedComicCard({
    super.key,
    required this.cardWidth,
    required this.comic,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context,
          OwnedIssuesItems(
            comic: comic,
          ),
        );
      },
      child: Container(
        width: cardWidth,
        constraints: const BoxConstraints(maxWidth: 190),
        decoration: BoxDecoration(
          color: ColorPalette.boxBackground200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImageBgPlaceholder(
              height: 125,
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${comic.stats?.issuesCount ?? 0} EP',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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
