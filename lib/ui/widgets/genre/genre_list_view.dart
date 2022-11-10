import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/core/providers/genre_provider.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_card.dart';
import 'package:d_reader_flutter/ui/widgets/genre/skeleton_genre_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenreListView extends ConsumerWidget {
  const GenreListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<GenreModel>> genres = ref.watch(genreProvider);
    bool isTablet = MediaQuery.of(context).size.width > 600;
    return genres.when(
      data: (data) {
        return SizedBox(
          height: 90,
          child: ListView.builder(
            itemCount: data.length > 4
                ? isTablet
                    ? 8
                    : 4
                : data.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GenreCard(
                genre: data[index],
              );
            },
          ),
        );
      },
      error: (err, stack) => Text('Error: $err'),
      loading: () => SizedBox(
        height: 90,
        child: ListView.builder(
          itemCount: 4,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => const SkeletonGenreCard(),
        ),
      ),
    );
  }
}
