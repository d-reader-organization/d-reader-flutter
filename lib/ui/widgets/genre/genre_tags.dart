import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tag.dart';
import 'package:flutter/material.dart';

class GenreTags extends StatelessWidget {
  final List<GenreModel> genres;
  const GenreTags({
    Key? key,
    required this.genres,
  }) : super(key: key);

  List<GenreModel> _genresWithMore() => genres.sublist(0, 6)
    ..add(
      GenreModel(color: '', name: '', slug: 'dots', icon: ''),
    ); // needs better approach?

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 4,
        runSpacing: 4,
        children: (genres.length >= 6 ? _genresWithMore() : genres)
            .map(
              (genre) => GenreTag(
                color: genre.color,
                name: genre.name,
              ),
            )
            .toList());
  }
}
