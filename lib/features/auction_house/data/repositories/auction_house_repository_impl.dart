import 'package:d_reader_flutter/features/auction_house/data/datasource/auction_house_remote_source.dart';
import 'package:d_reader_flutter/features/auction_house/domain/models/collection_stats.dart';
import 'package:d_reader_flutter/features/auction_house/domain/models/listing.dart';
import 'package:d_reader_flutter/features/auction_house/domain/repositories/auction_house_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class AuctionHouseRepositoryImpl implements AuctionHouseRepository {
  final AuctionHouseDataSource dataSource;

  AuctionHouseRepositoryImpl(this.dataSource);
  @override
  Future<Either<AppException, CollectionStatsModel?>> getCollectionStatus(
      {required int issueId}) {
    return dataSource.getCollectionStatus(issueId: issueId);
  }

  @override
  Future<Either<AppException, List<ListingModel>>> getListedItems(
      {String? queryString}) {
    return dataSource.getListedItems(queryString: queryString);
  }
}
