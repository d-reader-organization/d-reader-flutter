import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_notifier.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaginatedByUserId<T> extends StateNotifier<PaginationState<T>>
    implements IPaginationNotifier {
  final String? query;
  final int userId;
  final int itemsPerPage;
  final List<T> _items = [];
  bool isEnd = false, initialFetchDone = false;

  List<T> get data => _items;

  final Future<Either<AppException, List<T>>> Function({
    required int userId,
    required String query,
  }) fetch;

  PaginatedByUserId({
    required this.fetch,
    this.query,
    required this.userId,
    this.itemsPerPage = 20,
  }) : super(const PaginationState.loading());

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

    final response = await fetch(userId: userId, query: buildQueryString());
    response.fold((exception) {
      state = PaginationState.onGoingError(
        _items,
        'Error occured in fetching next items',
        StackTrace.fromString('PaginationNotifier.fetchNext()'),
      );
    }, (result) {
      if (result.length < itemsPerPage) {
        isEnd = true;
        state = PaginationState.data(_items..addAll(result));
        return;
      }

      state = PaginationState.data(_items..addAll(result));
    });
  }

  @override
  initialFetch() async {
    final response = await fetch(userId: userId, query: buildQueryString());
    response.fold((exception) {
      state = PaginationState.error(
        exception,
        StackTrace.fromString('PaginationNotifier.initialFetch()'),
      );
    }, (result) {
      if (result.isEmpty || result.length < itemsPerPage) {
        isEnd = true;
        state = PaginationState.data(_items..addAll(result));
        return;
      }

      state = PaginationState.data(_items..addAll(result));
      initialFetchDone = true;
    });
  }

  @override
  String buildQueryString() {
    return 'skip=${_items.length * itemsPerPage}&take=$itemsPerPage&$query';
  }
}
