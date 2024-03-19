import 'package:d_reader_flutter/features/comic/data/datasource/comic_remote_source.dart';
import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/comic/domain/repositories/comic_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class ComicRepositoryImpl implements ComicRepository {
  final ComicDataSource dataSource;

  ComicRepositoryImpl(this.dataSource);

  @override
  Future<void> bookmarkComic(String slug) {
    return dataSource.bookmarkComic(slug);
  }

  @override
  Future<Either<AppException, ComicModel?>> getComic(String slug) {
    return dataSource.getComic(slug);
  }

  @override
  Future<Either<AppException, List<ComicModel>>> getComics(
      {String? queryString}) {
    return dataSource.getComics(queryString: queryString);
  }

  @override
  Future<Either<AppException, List<ComicModel>>> getOwnedComics(
      {required int userId, required String query}) {
    return dataSource.getOwnedComics(userId: userId, query: query);
  }

  @override
  Future<void> rateComic({required String slug, required int rating}) {
    return dataSource.rateComic(slug: slug, rating: rating);
  }

  @override
  Future<void> updateComicFavourite(String slug) {
    return dataSource.updateComicFavourite(slug);
  }

  @override
  Future<Either<AppException, List<ComicModel>>> getFavoriteComics(
      {required int userId, required String query}) {
    return dataSource.getFavoriteComics(userId: userId, query: query);
  }
}
