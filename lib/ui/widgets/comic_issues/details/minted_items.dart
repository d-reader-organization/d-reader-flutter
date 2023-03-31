import 'package:d_reader_flutter/core/notifiers/receipts_notifier.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/list_row_item.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MintedItems extends ConsumerWidget {
  final String candyMachineAddress;
  const MintedItems({
    super.key,
    required this.candyMachineAddress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(receiptsAsyncProvider(candyMachineAddress));
    return provider.when(
      data: (receipts) {
        if (receipts.isEmpty) {
          return const Text('No items minted.');
        }
        return ListView.separated(
          itemCount: receipts.length,
          padding: const EdgeInsets.only(
            right: 4,
            left: 4,
            top: 12,
            bottom: 4,
          ),
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            return ReceiptListItem(
              receipt: receipts[index],
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
