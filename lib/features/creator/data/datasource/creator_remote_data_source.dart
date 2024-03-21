import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class CreatorDataSource {
  Future<Either<AppException, List<CreatorModel>>> getCreators(
      {String? queryString});
  Future<CreatorModel?> getCreator(String slug);
  Future<void> followCreator(String slug);
  Future<Either<AppException, List<CreatorModel>>> getFollowedByUser(
      {required int userId, required String query});
}

class CreatorRemoteDataSource implements CreatorDataSource {
  final NetworkService networkService;

  CreatorRemoteDataSource(this.networkService);

  @override
  Future<void> followCreator(String slug) async {
    await networkService.patch('/creator/follow/$slug');
  }

  @override
  Future<CreatorModel?> getCreator(String slug) async {
    final response = await networkService.get('/creator/get/$slug');

    return response.fold(
      (exception) => null,
      (result) => CreatorModel.fromJson(
        result.data,
      ),
    );
  }

  @override
  Future<Either<AppException, List<CreatorModel>>> getCreators(
      {String? queryString}) async {
    final response = await networkService.get('/creator/get?$queryString');

    return response.fold(
      (exception) {
        return Left(exception);
      },
      (result) {
        return Right(
          List<CreatorModel>.from(
            result.data.map(
              (item) => CreatorModel.fromJson(
                item,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Future<Either<AppException, List<CreatorModel>>> getFollowedByUser(
      {required int userId, required String query}) async {
    try {
      final response = await networkService
          .get('/creator/get/followed-by-user/$userId?$query');

      return response.fold(
        (exception) {
          return Left(exception);
        },
        (result) {
          return Right(
            List<CreatorModel>.from(
              result.data.map(
                (item) => CreatorModel.fromJson(
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
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier:
              '${exception.toString()}AuctionHouseRemoteDataSource.getListedItems',
        ),
      );
    }
  }
}
