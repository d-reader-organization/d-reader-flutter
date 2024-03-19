import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class ComicRepository {
  Future<Either<AppException, List<ComicModel>>> getComics(
      {String? queryString});
  Future<Either<AppException, ComicModel?>> getComic(String slug);
  Future<Either<AppException, List<ComicModel>>> getOwnedComics({
    required int userId,
    required String query,
  });
  Future<void> updateComicFavourite(String slug);
  Future<void> rateComic({
    required String slug,
    required int rating,
  });
  Future<void> bookmarkComic(String slug);
  Future<Either<AppException, List<ComicModel>>> getFavoriteComics({
    required int userId,
    required String query,
  });
}
