import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_args.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_notifier.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaginationNotifier<T> extends StateNotifier<PaginationState<T>>
    implements IPaginationNotifier {
  final Future<List<T>> Function({String? queryString}) fetch;
  final String? query;

  PaginationNotifier({
    required this.fetch,
    required this.query,
  }) : super(const PaginationState.loading());

  final List<T> _items = [];
  PaginationArgs args = PaginationArgs(skip: 0, take: 8);
  bool isEnd = false, initialFetchDone = false;

  @override
  void init() {
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