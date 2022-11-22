import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tag.dart';
import 'package:flutter/material.dart';

class GenreTags extends StatelessWidget {
  final List<GenreModel> genres;
  const GenreTags({
    Key? key,
    required this.genres,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: genres
          .map(
            (genre) => GenreTag(
              color: genre.color,
              name: genre.name,
            ),
          )
          .toList(),
    );
  }
}
