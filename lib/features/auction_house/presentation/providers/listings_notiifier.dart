import 'package:d_reader_flutter/features/auction_house/domain/models/listing.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_args.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_notifier.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListingsPaginationNotifier
    extends StateNotifier<PaginationState<ListingModel>>
    implements IPaginationNotifier {
  final Future<Either<AppException, List<ListingModel>>> Function(
      {String? queryString}) fetch;
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
    response.fold(
      (exception) {
        state = PaginationState.error(
          exception,
          StackTrace.fromString('PaginationNotifier.initialFetch()'),
        );
      },
      (result) {
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
      },
    );
  }

  @override
  String buildQueryString() {
    return 'skip=${args.skip * args.take}&take=${args.take}${query != null ? '&$query' : ''}';
  }
}
