import 'package:d_reader_flutter/features/auction_house/domain/models/collection_stats.dart';
import 'package:d_reader_flutter/features/auction_house/domain/models/listing.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class AuctionHouseRepository {
  Future<Either<AppException, List<ListingModel>>> getListedItems({
    String? queryString,
  });
  Future<Either<AppException, CollectionStatsModel?>> getCollectionStatus({
    required int issueId,
  });
}
