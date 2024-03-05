import 'package:d_reader_flutter/features/discover/genre/domain/models/genre.dart';
import 'package:d_reader_flutter/features/discover/genre/domain/providers/genre_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final genreProvider = FutureProvider<List<GenreModel>>((ref) async {
  final response = await ref.read(genreRepositoryProvider).getGenres();

  return response.fold(
    (exception) => [],
    (data) => data,
  );
});

final selectedGenresProvider = StateProvider<List<String>>(
  (ref) {
    return [];
  },
);
