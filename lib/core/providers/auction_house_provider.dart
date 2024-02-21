import 'package:d_reader_flutter/core/models/collection_stats.dart';
import 'package:d_reader_flutter/core/models/listed_item.dart';
import 'package:d_reader_flutter/core/providers/dio/dio_provider.dart';
import 'package:d_reader_flutter/core/repositories/auction_house/repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final auctionHouseRepositoryProvider = Provider<AuctionHouseRepositoryImpl>(
  (ref) {
    return AuctionHouseRepositoryImpl(
      client: ref.watch(dioProvider),
    );
  },
);

final listedItemsProvider = FutureProvider.autoDispose
    .family<List<ListingModel>, String>((ref, query) async {
  ref.invalidate(selectedItemsProvider);
  return ref
      .read(auctionHouseRepositoryProvider)
      .getListedItems(queryString: query);
});

final collectionStatsProvider = FutureProvider.autoDispose
    .family<CollectionStatsModel?, int>((ref, issueId) async {
  return ref
      .read(auctionHouseRepositoryProvider)
      .getCollectionStatus(issueId: issueId);
});

final selectedItemsProvider = StateProvider<List<ListingModel>>((ref) => []);

final selectedItemsPrice = StateProvider<int?>((ref) {
  int? sum;
  ref.watch(selectedItemsProvider).forEach((listing) {
    sum ??= 0;
    sum = sum! + listing.price;
  });
  return sum;
});
