import 'package:d_reader_flutter/features/auction_house/presentation/providers/auction_house_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/skeleton_row.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/stats_info.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solana/solana.dart' show lamportsPerSol;

class ListingStats extends ConsumerWidget {
  final ComicIssueModel issue;
  const ListingStats({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(collectionStatsProvider(issue.id));

    return provider.when(data: (collectionStats) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatsInfo(
            title: 'VOLUME',
            stats: issue.isFreeToRead
                ? '--'
                : '${collectionStats?.totalVolume != null ? (collectionStats!.totalVolume / lamportsPerSol).toStringAsFixed(2) : 0}◎',
          ),
          StatsInfo(
            title: 'SUPPLY',
            stats: issue.collectibleInfo != null &&
                    issue.collectibleInfo!.isSecondarySaleActive
                ? '${collectionStats?.supply}'
                : '--',
          ),
          StatsInfo(
            title: 'LISTED',
            stats: issue.isFreeToRead
                ? '--'
                : '${collectionStats?.itemsListed ?? 0}',
          ),
          StatsInfo(
            title: 'FLOOR',
            stats: issue.isFreeToRead
                ? 'FREE'
                : '${collectionStats?.floorPrice != null ? Formatter.formatLamportPrice(collectionStats!.floorPrice) : '--'}◎',
            isLastItem: true,
          ),
        ],
      );
    }, error: (Object error, StackTrace stackTrace) {
      return const Text('Something went wrong in candy machine stats');
    }, loading: () {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: SkeletonRow(),
      );
    });
  }
}
