import 'package:d_reader_flutter/features/discover/genre/domain/models/genre.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class GenreRepository {
  Future<Either<AppException, List<GenreModel>>> getGenres();
}
