import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/notifiers/listings_notifier.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/listed_item_row.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListedItems extends ConsumerWidget {
  final ComicIssueModel issue;
  const ListedItems({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(listingsAsyncProvider(issue));
    return provider.when(
      data: (listings) {
        if (listings.isEmpty) {
          return const Text('No items listed.');
        }
        return SizedBox(
          height: listings.length < 4 ? listings.length * 70 : 300,
          child: NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollNotification) {
                double maxScroll = notification.metrics.maxScrollExtent;
                double currentScroll = notification.metrics.pixels;
                double delta = MediaQuery.of(context).size.width * 0.1;
                if (maxScroll - currentScroll <= delta) {
                  ref.read(listingsAsyncProvider(issue).notifier).fetchNext();
                }
              }
              return true;
            },
            child: ListView.separated(
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
