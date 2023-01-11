import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/core/repositories/genre/genre_repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final genreProvider = FutureProvider<List<GenreModel>>((ref) async {
  return await IoCContainer.resolveContainer<GenreRepositoryImpl>().getGenres();
});
