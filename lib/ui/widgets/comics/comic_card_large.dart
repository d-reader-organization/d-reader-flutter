import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/pluralize_string.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/widgets/common/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags_default.dart';
import 'package:flutter/material.dart';

class ComicCardLarge extends StatelessWidget {
  final ComicModel comic;
  const ComicCardLarge({
    super.key,
    required this.comic,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.comicDetails}/${comic.slug}',
        );
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: CachedImageBgPlaceholder(
              imageUrl: comic.cover,
              height: 328,
              foregroundDecoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    ColorPalette.greyscale500,
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0, 2],
                ),
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comic.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${comic.stats?.issuesCount} ${pluralizeString(comic.stats?.issuesCount ?? 0, 'Episode')}',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  GenreTagsDefault(genres: comic.genres),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
