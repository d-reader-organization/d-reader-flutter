import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/notifiers/receipts_notifier.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/minted_item_row.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MintedItems extends ConsumerWidget {
  final ComicIssueModel issue;
  const MintedItems({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(receiptsAsyncProvider(issue));
    return provider.when(
      data: (receipts) {
        if (receipts.isEmpty) {
          return const Text('No items minted.');
        }
        return SizedBox(
          height: receipts.length < 5 ? receipts.length * 70 : 300,
          child: NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollNotification) {
                double maxScroll = notification.metrics.maxScrollExtent;
                double currentScroll = notification.metrics.pixels;
                double delta = MediaQuery.of(context).size.width * 0.1;
                if (maxScroll - currentScroll <= delta) {
                  ref.read(receiptsAsyncProvider(issue).notifier).fetchNext();
                }
              }
              return true;
            },
            child: ListView.separated(
              itemCount: receipts.length,
              physics: const PageScrollPhysics(),
              padding: const EdgeInsets.only(
                right: 4,
                left: 4,
                top: 12,
                bottom: 4,
              ),
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return MintedItemRow(
                  receipt: receipts[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  color: ColorPalette.boxBackground400,
                );
              },
            ),
          ),
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
