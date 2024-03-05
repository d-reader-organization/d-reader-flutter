import 'package:d_reader_flutter/features/genre/data/datasource/genre_remote_data_source.dart';
import 'package:d_reader_flutter/features/genre/domain/models/genre.dart';
import 'package:d_reader_flutter/features/genre/domain/repositories/genre_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class GenreRepositoryImpl implements GenreRepository {
  final GenreDataSource dataSource;

  GenreRepositoryImpl(this.dataSource);

  @override
  Future<Either<AppException, List<GenreModel>>> getGenres() {
    return dataSource.getGenres();
  }
}
