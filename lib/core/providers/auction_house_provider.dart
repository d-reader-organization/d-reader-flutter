import 'package:d_reader_flutter/core/models/collection_stats.dart';
import 'package:d_reader_flutter/core/models/listed_item.dart';
import 'package:d_reader_flutter/core/repositories/auction_house/repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final listedItemsProvider = FutureProvider.autoDispose
    .family<List<ListedItemModel>, int>((ref, issueId) async {
  ref.invalidate(selectedItemsProvider);
  return await IoCContainer.resolveContainer<AuctionHouseRepositoryImpl>()
      .getListedItems(issueId: issueId);
});

final collectionStatsProvider = FutureProvider.autoDispose
    .family<CollectionStatsModel?, int>((ref, issueId) async {
  return await IoCContainer.resolveContainer<AuctionHouseRepositoryImpl>()
      .getCollectionStatus(issueId: issueId);
});

final buyListedItemProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, query) async {
  return await IoCContainer.resolveContainer<AuctionHouseRepositoryImpl>()
      .executeSale(query: query);
});

final selectedItemsProvider = StateProvider<List<ListedItemModel>>((ref) => []);

final selectedItemsPrice = StateProvider<int?>((ref) {
  int? sum;
  ref.watch(selectedItemsProvider).forEach((listing) {
    sum ??= 0;
    sum = sum! + listing.price;
  });
  return sum;
});
