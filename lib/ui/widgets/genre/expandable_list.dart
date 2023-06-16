import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/core/providers/discover/filter_provider.dart';
import 'package:d_reader_flutter/core/providers/genre_provider.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_filter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExpandableGenreList extends ConsumerWidget {
  const ExpandableGenreList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<GenreModel>> genres = ref.watch(genreProvider);
    return genres.when(
      data: (data) {
        final double screenWidth = MediaQuery.of(context).size.width;
        data = ref.watch(showAllGenresProvider)
            ? data
            : data.sublist(0, screenWidth >= 440 ? 4 : 3);
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: data.map((item) {
            return GenreFilter(genre: item);
          }).toList(),
        );
      },
      error: (err, stack) => Text('Error: $err'),
      loading: () => const SizedBox(),
    );
  }
}
