import 'package:d_reader_flutter/features/auction_house/domain/models/collection_stats.dart';
import 'package:d_reader_flutter/features/auction_house/domain/models/listing.dart';

abstract class AuctionHouseRepository {
  Future<List<ListingModel>> getListedItems({
    String? queryString,
  });
  Future<CollectionStatsModel?> getCollectionStatus({required int issueId});
}
