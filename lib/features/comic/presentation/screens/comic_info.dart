import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/features/discover/genre/presentation/widgets/genre_tags_default.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ComicInfoView extends StatelessWidget {
  final ComicModel comic;
  const ComicInfoView({
    super.key,
    required this.comic,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: const Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                AspectRatio(
                  aspectRatio: 10 / 9,
                  child: CachedImageBgPlaceholder(
                    imageUrl: comic.cover,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'About',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  comic.description,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Divider(
                  thickness: 1,
                  color: ColorPalette.greyscale400,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Genres',
                  style: textTheme.titleMedium,
                ),
                GenreTagsDefault(
                  genres: comic.genres,
                  ignoreSublist: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
