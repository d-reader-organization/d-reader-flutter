import 'package:d_reader_flutter/core/models/collection_stats.dart';
import 'package:d_reader_flutter/core/models/listed_item.dart';

abstract class AuctionHouseRepository {
  Future<String?> listItem({
    required String sellerAddress,
    required String mintAccount,
    required int price,
    String? printReceipt,
  });
  Future<List<ListingModel>> getListedItems(
      {required int issueId, required String query});
  Future<CollectionStatsModel?> getCollectionStatus({required int issueId});
  Future<String?> executeSale({required String query});
  Future<String?> delistItem({required String nftAddress});
  Future<String?> buyItem({
    required String mintAccount,
    required int price,
    required String sellerAddress,
    required String buyerAddress,
  });

  Future<List<String>> buyMultipleItems(Map<String, dynamic> query);
}
