import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/notifiers/listings_notifier.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/tabs/listings/listed_items.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/tabs/listings/stats.dart';
import 'package:d_reader_flutter/ui/widgets/discover/common/on_going_bottom.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IssueListings extends ConsumerWidget {
  final ComicIssueModel issue;
  const IssueListings({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollNotification) {
          double maxScroll = notification.metrics.maxScrollExtent;
          double currentScroll = notification.metrics.pixels;
          double delta = MediaQuery.sizeOf(context).width * 0.2;
          if (maxScroll - currentScroll <= delta) {
            ref.read(listingsPaginatedProvider(issue).notifier).fetchNext();
          }
        }
        return true;
      },
      child: ListView(
        shrinkWrap: true,
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
          OnGoingBottomWidget(
            provider: ref.watch(
              listingsPaginatedProvider(
                issue,
              ),
            ),
            sliverWidget: false,
          ),
        ],
      ),
    );
  }
}
