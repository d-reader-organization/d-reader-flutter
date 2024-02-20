import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags_default.dart';
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
                const Text(
                  'About',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  comic.description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
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
                const Text(
                  'Genres',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
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
