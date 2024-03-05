import 'package:d_reader_flutter/shared/domain/models/genre.dart';

abstract class GenreRepository {
  Future<List<GenreModel>> getGenres();
}
