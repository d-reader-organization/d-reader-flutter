import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/listed_item.dart';
import 'package:d_reader_flutter/core/providers/auction_house_provider.dart';
import 'package:d_reader_flutter/core/providers/socket_client_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final listingsAsyncProvider = AsyncNotifierProvider.autoDispose
    .family<ListingsAsyncNotifier, List<ListingModel>, ComicIssueModel>(
  ListingsAsyncNotifier.new,
);

class ListingsAsyncNotifier extends AutoDisposeFamilyAsyncNotifier<
    List<ListingModel>, ComicIssueModel> {
  @override
  FutureOr<List<ListingModel>> build(ComicIssueModel arg) async {
    final listings = await ref.read(listedItemsProvider(arg.id).future);

    final socket = ref.read(socketProvider).socket;
    socket.connect();
    ref.onDispose(() {
      socket.close();
    });

    socket.on('comic-issue/${arg.id}/item-listed', (data) {
      final newListing = ListingModel.fromJson(data);
      ref.invalidate(collectionStatsProvider);
      state = AsyncValue.data([newListing, ...?state.value]);
    });

    socket.on('comic-issue/${arg.id}/item-sold', (data) {
      final soldListing = ListingModel.fromJson(data);
      ref.invalidate(collectionStatsProvider);
      state = AsyncValue.data([...?state.value?..remove(soldListing)]);
    });

    socket.on('comic-issue/${arg.id}/item-delisted', (data) {
      final newDelistedItem = ListingModel.fromJson(data);
      ref.invalidate(collectionStatsProvider);
      state = AsyncValue.data([...?state.value?..remove(newDelistedItem)]);
    });

    return listings;
  }
}
