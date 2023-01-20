import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GenreTagsDefault extends StatelessWidget {
  final List<GenreModel> genres;
  const GenreTagsDefault({
    Key? key,
    required this.genres,
  }) : super(key: key);

  List<GenreModel> _genresWithMore() => genres.sublist(0, 4)
    ..add(
      GenreModel(color: '', name: '', slug: 'dots', icon: ''),
    );

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: (genres.length >= 4 ? _genresWithMore() : genres)
            .map((genre) => Container(
                  padding: const EdgeInsets.all(4),
                  child: genre.name.isNotEmpty
                      ? Row(
                          children: [
                            SvgPicture.network(genre.icon,
                                color: Colors.white, height: 16),
                            Text(
                              genre.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      : const EmptyGenreTag(),
                ))
            .toList());
  }
}
