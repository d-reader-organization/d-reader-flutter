import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/listed_item.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
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
  bool isEnd = false;
  bool isLoading = false;
  @override
  FutureOr<List<ListingModel>> build(ComicIssueModel arg) async {
    final listings = await ref.read(
      listedItemsProvider(
        ListingsProviderArg(
          issueId: arg.id,
          query: 'skip=0&take=10',
        ),
      ).future,
    );
    final socket =
        ref.read(socketProvider(ref.read(environmentProvider).apiUrl)).socket;
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

  fetchNext() async {
    if (isEnd || isLoading) {
      return;
    }
    isLoading = true;
    final newListings = await ref.read(
      listedItemsProvider(
        ListingsProviderArg(
          issueId: arg.id,
          query: 'skip=${state.value?.length}&take=10',
        ),
      ).future,
    );
    if (newListings.isEmpty) {
      isEnd = true;
      return;
    }
    isLoading = false;
    state = AsyncValue.data([...?state.value, ...newListings]);
  }
}
