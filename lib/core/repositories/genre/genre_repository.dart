import 'package:d_reader_flutter/core/models/genre.dart';

abstract class GenreRepository {
  Future<List<GenreModel>> getGenres();
}
