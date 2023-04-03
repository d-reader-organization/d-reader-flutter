import 'package:d_reader_flutter/core/providers/auction_house_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/details_list_item.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListedItems extends ConsumerWidget {
  final int issueId;
  const ListedItems({
    super.key,
    required this.issueId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(listedItemsProvider(issueId));
    return provider.when(
      data: (listings) {
        if (listings.isEmpty) {
          return const Text('No items listed.');
        }
        return ListView.separated(
          itemCount: listings.length,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            return ListedItemRow(
              listing: listings[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: ColorPalette.boxBackground400,
            );
          },
        );
      },
      error: (error, stackTrace) {
        print('Listed items error: ${error.toString()}');
        print(stackTrace);
        return const Text('Something went wrong');
      },
      loading: () => const SkeletonRow(),
    );
  }
}
