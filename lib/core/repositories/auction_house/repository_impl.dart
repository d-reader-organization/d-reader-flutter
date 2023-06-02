import 'package:d_reader_flutter/core/models/collection_stats.dart';
import 'package:d_reader_flutter/core/models/listed_item.dart';
import 'package:d_reader_flutter/core/repositories/auction_house/repository.dart';

import 'package:dio/dio.dart';

class AuctionHouseRepositoryImpl implements AuctionHouseRepository {
  final Dio client;
  AuctionHouseRepositoryImpl({
    required this.client,
  });

  @override
  Future<String?> listItem({
    required String mintAccount,
    required int price,
    String? printReceipt,
  }) {
    return client
        .get(
          '/auction-house/transactions/list?mintAccount=$mintAccount&price=$price&printReceipt=$printReceipt',
        )
        .then((value) => value.data);
  }

  @override
  Future<List<ListingModel>> getListedItems({
    required int issueId,
    required String query,
  }) async {
    final response = await client
        .get('/auction-house/get/listings/$issueId?$query')
        .then((value) => value.data);
    if (response == null) {
      return [];
    }
    return List<ListingModel>.from(
      response.map(
        (item) => ListingModel.fromJson(
          item,
        ),
      ),
    );
  }

  @override
  Future<CollectionStatsModel?> getCollectionStatus(
      {required int issueId}) async {
    final response = await client
        .get('/auction-house/get/collection-stats/$issueId')
        .then((value) => value.data);

    return response == null ? null : CollectionStatsModel.fromJson(response);
  }

  @override
  Future<String?> executeSale({required String query}) async {
    final responseBody = await client
        .get('/auction-house/transactions/execute-sale?$query')
        .then((value) => value.data);
    return responseBody;
  }

  @override
  Future<String?> delistItem({required String mint}) {
    return client
        .get('/auction-house/transactions/cancel-listing?mint=$mint')
        .then((value) => value.data);
  }

  @override
  Future<String?> buyItem({
    required String mintAccount,
    required int price,
    required String seller,
  }) {
    return client
        .get(
          '/auction-house/transactions/instant-buy?mintAccount=$mintAccount&price=$price&seller=$seller',
        )
        .then((value) => value.data);
  }

  @override
  Future<List<String>> buyMultipleItems(Map<String, dynamic> query) async {
    final responseBody = await client
        .get(
      '/auction-house/transactions/multiple-buy',
      queryParameters: query,
    )
        .then(
      (value) {
        return value.data;
      },
    );
    return responseBody == null ? [] : List<String>.from(responseBody);
  }
}
