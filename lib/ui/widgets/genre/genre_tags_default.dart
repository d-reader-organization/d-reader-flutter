import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tag.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GenreTagsDefault extends StatelessWidget {
  final List<GenreModel> genres;
  final bool withHorizontalScroll;
  const GenreTagsDefault({
    Key? key,
    required this.genres,
    this.withHorizontalScroll = false,
  }) : super(key: key);

  List<GenreModel> _genresWithMore(int sublistLimit) =>
      genres.sublist(0, sublistLimit)
        ..add(
          GenreModel(color: '', name: '', slug: 'dots', icon: ''),
        );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sublistLimit = getGenreLimit(screenWidth);
    return withHorizontalScroll
        ? SizedBox(
            height: 21,
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
                    ? _genresWithMore(sublistLimit)
                    : genres)
                .map(
                  (genre) => TagContainer(genre: genre),
                )
                .toList());
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
