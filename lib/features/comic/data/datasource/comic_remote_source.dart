import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class ComicDataSource {
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

class ComicRemoteDataSource implements ComicDataSource {
  final NetworkService networkService;

  ComicRemoteDataSource(this.networkService);

  @override
  Future<void> bookmarkComic(String slug) {
    return networkService.patch('/comic/bookmark/$slug');
  }

  @override
  Future<Either<AppException, ComicModel?>> getComic(String slug) async {
    try {
      final response = await networkService.get('/comic/get/$slug');
      return response.fold((exception) => Left(exception), (result) {
        return Right(ComicModel.fromJson(result.data));
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier: '${exception.toString()}ComicRemoteDataSource.getComic',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<ComicModel>>> getComics(
      {String? queryString}) async {
    try {
      final response = await networkService.get('/comic/get?$queryString');
      return response.fold((exception) => Left(exception), (result) {
        return Right(
          List<ComicModel>.from(
            result.data.map(
              (item) => ComicModel.fromJson(
                item,
              ),
            ),
          ),
        );
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier: '${exception.toString()}ComicRemoteDataSource.getComics',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<ComicModel>>> getOwnedComics(
      {required int userId, required String query}) async {
    try {
      final response =
          await networkService.get('/comic/get/by-owner/$userId?$query');
      return response.fold((exception) => Left(exception), (result) {
        return Right(
          List<ComicModel>.from(
            result.data.map(
              (item) => ComicModel.fromJson(
                item,
              ),
            ),
          ),
        );
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier: '${exception.toString()}ComicRemoteDataSource.getComics',
        ),
      );
    }
  }

  @override
  Future<void> rateComic({required String slug, required int rating}) {
    return networkService.patch(
      '/comic/rate/$slug',
      data: {
        'rating': rating,
      },
    );
  }

  @override
  Future<void> updateComicFavourite(String slug) {
    return networkService.patch('/comic/favouritise/$slug');
  }

  @override
  Future<Either<AppException, List<ComicModel>>> getFavoriteComics(
      {required int userId, required String query}) async {
    try {
      final response =
          await networkService.get('/comic/get/favorites/$userId?$query');

      return response.fold((exception) => Left(exception), (result) {
        return Right(
          List<ComicModel>.from(
            result.data.map(
              (json) => ComicModel.fromJson(
                json,
              ),
            ),
          ),
        );
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occured',
          statusCode: 500,
          identifier:
              '${exception.toString()}ComicRemoteDataSource.getFavoriteComics',
        ),
      );
    }
  }
}
