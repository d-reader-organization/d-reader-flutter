import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/listed_item.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/notifiers/pagination_notifier.dart';
import 'package:d_reader_flutter/core/providers/auction_house_provider.dart';
import 'package:d_reader_flutter/core/providers/socket_client_provider.dart';
import 'package:d_reader_flutter/core/states/pagination_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final listingsPaginatedProvider = StateNotifierProvider.autoDispose.family<
    ListingsPaginationNotifier, PaginationState<ListingModel>, ComicIssueModel>(
  (ref, arg) {
    final fetch = ref.read(auctionHouseRepositoryProvider).getListedItems;
    return ListingsPaginationNotifier(
      fetch: fetch,
      query: 'comicIssueId=${arg.id}',
      ref: ref,
      comicIssueId: arg.id,
    )..init();
  },
);

class ListingsPaginationNotifier
    extends StateNotifier<PaginationState<ListingModel>>
    implements IPaginationNotifier {
  final Future<List<ListingModel>> Function({String? queryString}) fetch;
  final String? query;
  final AutoDisposeStateNotifierProviderRef ref;
  final int comicIssueId;

  ListingsPaginationNotifier({
    required this.fetch,
    required this.query,
    required this.ref,
    required this.comicIssueId,
  }) : super(const PaginationState.loading());

  final List<ListingModel> _items = [];
  PaginationArgs args = PaginationArgs(skip: 0, take: 8);
  bool isEnd = false, initialFetchDone = false;

  @override
  void init({Function()? onInit}) {
    final socket =
        ref.read(socketProvider(ref.read(environmentProvider).apiUrl)).socket;
    socket.connect();
    ref.onDispose(() {
      socket.close();
    });

    socket.on('comic-issue/$comicIssueId/item-listed', (data) {
      final newListing = ListingModel.fromJson(data);
      ref.invalidate(collectionStatsProvider);
      state = PaginationState.data([
        newListing,
        ..._items,
      ]);
    });

    socket.on('comic-issue/$comicIssueId/item-sold', (data) {
      final soldListing = ListingModel.fromJson(data);
      ref.invalidate(collectionStatsProvider);
      state = PaginationState.data([..._items..remove(soldListing)]);
    });

    socket.on('comic-issue/$comicIssueId/item-delisted', (data) {
      final newDelistedItem = ListingModel.fromJson(data);
      ref.invalidate(collectionStatsProvider);
      state = PaginationState.data([..._items..remove(newDelistedItem)]);
    });
    initialFetch();
  }

  @override
  fetchNext() async {
    if (isEnd ||
        state == PaginationState.onGoingLoading(_items) ||
        !initialFetchDone) {
      return;
    }
    state = PaginationState.onGoingLoading(_items);

    try {
      final result = await fetch(queryString: buildQueryString());
      if (result.length < args.take) {
        isEnd = true;
        state = PaginationState.data(_items..addAll(result));
        return;
      }
      args = PaginationArgs.copyWith(
        skip: args.skip + 1,
        take: args.take,
      );
      state = PaginationState.data(_items..addAll(result));
    } catch (e) {
      state = PaginationState.onGoingError(
        _items,
        'Error occured in fetching next items',
        StackTrace.fromString('PaginationNotifier.fetchNext()'),
      );
    }
  }

  @override
  initialFetch() async {
    try {
      final result = await fetch(queryString: buildQueryString());
      if (result.isEmpty || result.length < args.take) {
        isEnd = true;
        state = PaginationState.data(_items..addAll(result));
        return;
      }
      args = PaginationArgs.copyWith(
        skip: args.skip + 1,
        take: args.take,
      );
      state = PaginationState.data(_items..addAll(result));
      initialFetchDone = true;
    } catch (e) {
      state = PaginationState.error(
        e,
        StackTrace.fromString('PaginationNotifier.initialFetch()'),
      );
    }
  }

  @override
  String buildQueryString() {
    return 'skip=${args.skip * args.take}&take=${args.take}&$query';
  }
}
