import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/states/pagination_state.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/creators/creators_results_builder.dart';
import 'package:flutter/material.dart';

class CreatorsList extends StatelessWidget {
  final PaginationState<CreatorModel> provider;
  const CreatorsList({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return provider.when(
      data: (creators) {
        return CreatorsListBuilder(creators: creators);
      },
      error: (err, stack) => Text(
        'Error: $err',
        style: const TextStyle(color: Colors.red),
      ),
      loading: () => ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return const SizedBox(height: 56, child: SkeletonRow());
        },
      ),
      onGoingError: (List<CreatorModel> items, Object? e, StackTrace? stk) {
        return CreatorsListBuilder(
          creators: items,
        );
      },
      onGoingLoading: (List<CreatorModel> items) {
        return CreatorsListBuilder(
          creators: items,
        );
      },
    );
  }
}

class ComicListItemSkeleton extends StatelessWidget {
  const ComicListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const SkeletonCard(
                    height: 150,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          const Expanded(
            flex: 7,
            child: SkeletonCard(
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
