import 'package:d_reader_flutter/features/auction_house/domain/providers/auction_house_provider.dart';
import 'package:d_reader_flutter/features/auction_house/domain/models/listing.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/features/auction_house/presentation/providers/listings_notiifier.dart';
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
