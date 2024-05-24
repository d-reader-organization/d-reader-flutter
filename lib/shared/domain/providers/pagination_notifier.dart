import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_args.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_notifier.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaginationNotifier<T> extends StateNotifier<PaginationState<T>>
    implements IPaginationNotifier {
  final Future<Either<AppException, List<T>>> Function({String? queryString})
      fetch;
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

    final response = await fetch(queryString: buildQueryString());
    response.fold((exception) {
      state = PaginationState.onGoingError(
        _items,
        'Error occured in fetching next items',
        StackTrace.fromString('PaginationNotifier.fetchNext()'),
      );
    }, (result) {
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
    });
  }

  @override
  initialFetch() async {
    final response = await fetch(queryString: buildQueryString());
    response.fold((exception) {
      state = PaginationState.error(
        exception,
        StackTrace.fromString('PaginationNotifier.initialFetch()'),
      );
    }, (result) {
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
    });
  }

  @override
  String buildQueryString() {
    return 'skip=${args.skip * args.take}&take=${args.take}${query != null ? '&$query' : ''}';
  }
}
