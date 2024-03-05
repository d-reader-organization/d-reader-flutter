import 'package:d_reader_flutter/features/auction_house/domain/models/collection_stats.dart';
import 'package:d_reader_flutter/features/auction_house/domain/models/listing.dart';
import 'package:d_reader_flutter/features/auction_house/domain/providers/auction_house_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final collectionStatsProvider = FutureProvider.autoDispose
    .family<CollectionStatsModel?, int>((ref, issueId) async {
  final response = await ref
      .read(auctionHouseRepositoryProvider)
      .getCollectionStatus(issueId: issueId);

  return response.fold(
    (exception) {
      throw exception;
    },
    (data) {
      return data;
    },
  );
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
