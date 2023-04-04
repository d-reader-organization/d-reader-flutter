import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/collection_stats.dart';
import 'package:d_reader_flutter/core/models/listed_item.dart';
import 'package:d_reader_flutter/core/repositories/auction_house/repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';
import 'package:d_reader_flutter/ui/utils/append_default_query_string.dart';

class AuctionHouseRepositoryImpl implements AuctionHouseRepository {
  @override
  Future<String?> listItem({
    required String mintAccount,
    required int price,
    String? printReceipt,
  }) {
    return ApiService.instance.apiCallGet(
        '/auction-house/transactions/list?mintAccount=$mintAccount&price=$price&printReceipt=$printReceipt');
  }

  @override
  Future<List<ListedItemModel>> getListedItems({required int issueId}) async {
    final String? responseBody = await ApiService.instance.apiCallGet(
        '/auction-house/get/listings/$issueId?${appendDefaultQuery(null)}');

    if (responseBody == null) {
      return [];
    }
    Iterable decodedData = jsonDecode(responseBody);
    return List<ListedItemModel>.from(
      decodedData.map(
        (item) => ListedItemModel.fromJson(
          item,
        ),
      ),
    );
  }

  @override
  Future<CollectionStatsModel?> getCollectionStatus(
      {required int issueId}) async {
    final String? responseBody = await ApiService.instance
        .apiCallGet('/auction-house/get/collection-stats/$issueId');
    return responseBody == null
        ? null
        : CollectionStatsModel.fromJson(jsonDecode(responseBody));
  }

  @override
  Future<String?> executeSale({required String query}) async {
    final String? responseBody = await ApiService.instance
        .apiCallGet('/auction-house/transactions/execute-sale?$query');
    return responseBody;
  }

  @override
  Future<String?> delistItem({required String mint}) {
    return ApiService.instance
        .apiCallGet('/auction-house/transactions/cancel-listing?mint=$mint');
  }

  @override
  Future<String?> buyItem({
    required String mint,
    required int price,
    required String sellerAddress,
  }) {
    return ApiService.instance.apiCallGet(
        '/auction-house/transactions/instant-buy?mint=$mint&price=$price&seller=$sellerAddress');
  }
}
