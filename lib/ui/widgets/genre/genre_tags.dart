import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tag.dart';
import 'package:flutter/material.dart';

int getGenreLimit(double screenWidth) {
  if (screenWidth > 360) {
    return 5;
  }
  return 4;
}

class GenreTags extends StatelessWidget {
  final List<GenreModel> genres;
  const GenreTags({
    Key? key,
    required this.genres,
  }) : super(key: key);

  List<GenreModel> _genresWithMore(int sublistEnd) =>
      genres.sublist(0, sublistEnd)
        ..add(
          GenreModel(color: '', name: '', slug: 'dots', icon: ''),
        ); // needs better approach?

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final genreLimit = getGenreLimit(screenWidth);
    return Wrap(
        spacing: 4,
        runSpacing: 4,
        children:
            (genres.length >= genreLimit ? _genresWithMore(genreLimit) : genres)
                .map(
                  (genre) => GenreTag(
                    color: genre.color,
                    name: genre.name,
                  ),
                )
                .toList());
  }
}
