import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/episode_circle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComicCard extends StatelessWidget {
  final ComicModel comic;
  const ComicCard({
    Key? key,
    required this.comic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      height: 255,
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: CachedNetworkImageProvider(comic.cover),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12,
            top: 16,
            child: EpisodeCircle(text: '${comic.stats?.issuesCount} EPs'),
          ),
          Positioned(
            left: 12,
            bottom: 40,
            child: SizedBox(
              width: 140,
              child: Text(
                comic.name,
                softWrap: true,
                style: textTheme.titleSmall,
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 16,
            child: Row(
              children: [
                Text(
                  comic.creator.name,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Icon(
                  Icons.verified,
                  color: ColorPalette.dReaderYellow100,
                  size: 16,
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            bottom: 16,
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.heart,
                  color: ColorPalette.dReaderGrey,
                  size: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  comic.stats?.favouritesCount.toString() ?? '0',
                  style: textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
