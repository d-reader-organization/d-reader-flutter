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
        final double screenWidth = MediaQuery.sizeOf(context).width;
        final bool isTablet = screenWidth >= 600;
        data = ref.watch(showAllGenresProvider)
            ? data
            : data.sublist(0, isTablet ? 8 : 4);
        return GridView.builder(
          itemCount: data.length,
          physics: const PageScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 8 : 4,
            crossAxisSpacing: screenWidth <= 380 ? 8 : 16,
            mainAxisSpacing: screenWidth <= 380 ? 8 : 16,
            mainAxisExtent: 87,
          ),
          itemBuilder: (context, index) {
            return GenreFilter(
              genre: data[index],
            );
          },
        );
      },
      error: (err, stack) => Text('Error: $err'),
      loading: () => const SizedBox(),
    );
  }
}
