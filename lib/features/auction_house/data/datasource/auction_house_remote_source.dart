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
      {required int issueId}) {
    // TODO: implement getCollectionStatus
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<ListingModel>>> getListedItems(
      {String? queryString}) {
    // TODO: implement getListedItems
    throw UnimplementedError();
  }
}

  // @override
  // Future<List<ListingModel>> getListedItems({
  //   String? queryString,
  // }) async {
  //   final response = await client
  //       .get('/auction-house/get/listed-items?$queryString')
  //       .then((value) => value.data);
  //   if (response == null) {
  //     return [];
  //   }
  //   return List<ListingModel>.from(
  //     response.map(
  //       (item) => ListingModel.fromJson(
  //         item,
  //       ),
  //     ),
  //   );
  // }

  // @override
  // Future<CollectionStatsModel?> getCollectionStatus(
  //     {required int issueId}) async {
  //   final response = await client
  //       .get('/auction-house/get/collection-stats/$issueId')
  //       .then((value) => value.data);

  //   return response == null ? null : CollectionStatsModel.fromJson(response);
  // }