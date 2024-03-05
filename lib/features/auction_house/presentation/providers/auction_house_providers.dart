import 'package:d_reader_flutter/core/providers/auction_house_provider.dart';
import 'package:d_reader_flutter/features/auction_house/domain/models/collection_stats.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final collectionStatsProvider = FutureProvider.autoDispose
    .family<CollectionStatsModel?, int>((ref, issueId) async {
  return ref
      .read(auctionHouseRepositoryProvider)
      .getCollectionStatus(issueId: issueId);
});
