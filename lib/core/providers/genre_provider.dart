import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/core/repositories/genre/genre_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final genreProvider = FutureProvider<List<GenreModel>>((ref) async {
  GenreRepositoryImpl genreRepository = GenreRepositoryImpl();
  return await genreRepository.getGenres();
});
