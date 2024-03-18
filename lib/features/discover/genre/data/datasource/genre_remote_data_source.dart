import 'package:d_reader_flutter/features/discover/genre/domain/models/genre.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class GenreDataSource {
  Future<Either<AppException, List<GenreModel>>> getGenres();
}

class GenreRemoteDataSource implements GenreDataSource {
  final NetworkService networkService;

  GenreRemoteDataSource(this.networkService);

  @override
  Future<Either<AppException, List<GenreModel>>> getGenres() async {
    try {
      final response = await networkService.get('/genre/get');

      return response.fold(
        (exception) {
          return const Right([]);
        },
        (result) {
          return Right(
            List<GenreModel>.from(
              result.data.map(
                (item) => GenreModel.fromJson(
                  item,
                ),
              ),
            ),
          );
        },
      );
    } catch (exception) {
      return Left(
        AppException(
          identifier: 'GenreRemoteDataSource.getGenres',
          statusCode: 500,
          message: exception.toString(),
        ),
      );
    }
  }
}
