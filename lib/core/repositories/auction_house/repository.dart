import 'package:d_reader_flutter/core/models/collection_stats.dart';
import 'package:d_reader_flutter/core/models/listing_item.dart';

abstract class AuctionHouseRepository {
  Future<String?> listItem({
    required String mintAccount,
    required double price,
    String? printReceipt,
  });
  Future<List<ListingItemModel>> getListedItems({required int issueId});
  Future<CollectionStatsModel?> getCollectionStatus({required int issueId});
  Future<String?> executeSale({required String query});
  Future<String?> delistItem({required String query});
}
