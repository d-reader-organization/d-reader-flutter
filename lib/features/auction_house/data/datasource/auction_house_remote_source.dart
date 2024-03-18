import 'package:d_reader_flutter/features/auction_house/domain/models/collection_stats.dart';
import 'package:d_reader_flutter/features/auction_house/domain/models/listing.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class AuctionHouseDataSource {
  Future<Either<AppException, List<ListingModel>>> getListedItems({
    String? queryString,
  });
  Future<Either<AppException, CollectionStatsModel?>> getCollectionStatus({
    required int issueId,
  });
}

class AuctionHouseRemoteDataSource implements AuctionHouseDataSource {
  final NetworkService networkService;

  AuctionHouseRemoteDataSource(this.networkService);

  @override
  Future<Either<AppException, CollectionStatsModel?>> getCollectionStatus(
      {required int issueId}) async {
    try {
      final response = await networkService
          .get('/auction-house/get/collection-stats/$issueId');
      return response.fold((exception) {
        return Left(exception);
      }, (result) {
        return Right(
          CollectionStatsModel.fromJson(
            result.data,
          ),
        );
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier:
              '${exception.toString()}AuctionHouseRemoteDataSource.getCollectionStatus',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<ListingModel>>> getListedItems(
      {String? queryString}) async {
    try {
      final response = await networkService
          .get('/auction-house/get/listed-items?$queryString');

      return response.fold((exception) => Left(exception), (result) {
        final data = result.data;

        if (data == null) {
          return const Right([]);
        }
        return Right(
          List<ListingModel>.from(
            data.map(
              (item) => ListingModel.fromJson(
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
          identifier:
              '${exception.toString()}AuctionHouseRemoteDataSource.getListedItems',
        ),
      );
    }
  }
}
