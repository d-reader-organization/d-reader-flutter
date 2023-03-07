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

  List<GenreModel> _genresWithMore(int sublistLimit) =>
      genres.sublist(0, sublistLimit)
        ..add(
          GenreModel(color: '', name: '', slug: 'dots', icon: ''),
        );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sublistLimit = screenWidth > 360 ? 4 : 3;
    return Row(
        children: (genres.length >= sublistLimit
                ? _genresWithMore(sublistLimit)
                : genres)
            .map((genre) => Container(
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.only(right: 4),
                  child: genre.name.isNotEmpty
                      ? Row(
                          children: [
                            SvgPicture.network(
                              genre.icon,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
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
