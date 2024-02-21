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
  Future<List<ListingModel>> getListedItems({
    String? queryString,
  }) async {
    final response = await client
        .get('/auction-house/get/listed-items?$queryString')
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
}
