import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

int getGenreLimit(double screenWidth) {
  if (screenWidth > 360) {
    return 5;
  }
  return 4;
}

List<GenreModel> _genresWithMore(List<GenreModel> genres, int sublistLimit) =>
    genres.sublist(0, sublistLimit)
      ..add(
        GenreModel(color: '', name: '', slug: 'dots', icon: ''),
      );

class GenreTagsDefault extends StatelessWidget {
  final List<GenreModel> genres;
  final bool withHorizontalScroll;
  const GenreTagsDefault({
    Key? key,
    required this.genres,
    this.withHorizontalScroll = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final sublistLimit = getGenreLimit(screenWidth);
    return withHorizontalScroll
        ? SizedBox(
            height: 24,
            child: ListView.builder(
              itemCount: genres.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                GenreModel genre = genres[index];
                return TagContainer(genre: genre);
              },
            ),
          )
        : Wrap(
            spacing: 4,
            runSpacing: 4,
            children: (genres.length >= sublistLimit
                    ? _genresWithMore(genres, sublistLimit)
                    : genres)
                .map(
                  (genre) => TagContainer(genre: genre),
                )
                .toList());
  }
}

class DiscoverGenreTagsDefault extends StatelessWidget {
  final List<GenreModel> genres;
  const DiscoverGenreTagsDefault({
    super.key,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: (genres.length > 2 ? _genresWithMore(genres, 2) : genres)
          .map(
            (genre) => TagContainer(
              genre: genre,
              color: ColorPalette.greyscale200,
            ),
          )
          .toList(),
    );
  }
}

class TagContainer extends StatelessWidget {
  final GenreModel genre;
  final Color color;
  const TagContainer({
    super.key,
    required this.genre,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 2,
        right: 2,
        bottom: 2,
      ),
      margin: const EdgeInsets.only(right: 4),
      child: genre.name.isNotEmpty
          ? Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.network(
                  genre.icon,
                  colorFilter: ColorFilter.mode(
                    color,
                    BlendMode.srcIn,
                  ),
                  height: 16,
                  width: 16,
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  genre.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                ),
              ],
            )
          : const EmptyGenreTag(),
    );
  }
}

class EmptyGenreTag extends StatelessWidget {
  const EmptyGenreTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: ColorPalette.boxBackground400, width: 1)),
      child: const Icon(
        Icons.more_horiz_outlined,
        color: ColorPalette.boxBackground400,
        size: 15,
      ),
    );
  }
}
