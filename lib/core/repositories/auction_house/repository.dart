import 'package:d_reader_flutter/core/models/collection_stats.dart';
import 'package:d_reader_flutter/core/models/listed_item.dart';

abstract class AuctionHouseRepository {
  Future<List<ListingModel>> getListedItems({
    required String query,
  });
  Future<CollectionStatsModel?> getCollectionStatus({required int issueId});
}
