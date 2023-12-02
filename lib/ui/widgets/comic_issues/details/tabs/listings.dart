import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/providers/auction_house_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/listed_items.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:d_reader_flutter/ui/widgets/common/stats_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solana/solana.dart' show lamportsPerSol;

class IssueListings extends StatelessWidget {
  final ComicIssueModel issue;
  const IssueListings({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        return true;
      },
      child: ListView(
        shrinkWrap: true,
        physics: const PageScrollPhysics(),
        children: [
          ListingStats(
            issue: issue,
          ),
          const SizedBox(
            height: 16,
          ),
          // const ListingFilters(),
          // const SizedBox(
          //   height: 16,
          // ),
          ListedItems(
            issue: issue,
          ),
        ],
      ),
    );
  }
}

class ListingFilters extends ConsumerStatefulWidget {
  const ListingFilters({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListingFiltersState();
}

class _ListingFiltersState extends ConsumerState<ListingFilters> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
                constraints: const BoxConstraints(minHeight: 46),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SvgPicture.asset(
                    'assets/icons/search.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                fillColor: ColorPalette.greyscale500,
                hintText: '#1203...',
                hintStyle: const TextStyle(
                  color: ColorPalette.greyscale200,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: ColorPalette.greyscale300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: ColorPalette.greyscale300,
                  ),
                )),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 46),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: ColorPalette.greyscale500,
                border: Border.all(
                  color: ColorPalette.greyscale300,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: .2,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/arrow_down.svg',
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 46),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorPalette.greyscale500,
                border: Border.all(
                  color: ColorPalette.greyscale300,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                'assets/icons/filter.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

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
            stats: issue.isSecondarySaleActive
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
                : '${collectionStats?.floorPrice != null ? formatLamportPrice(collectionStats!.floorPrice) : '--'}◎',
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
