import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/notifiers/listings_notifier.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/listed_item_row.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
          return const Text(
            'No items listed.',
            textAlign: TextAlign.center,
          );
        }
        return ListView.builder(
          itemCount: listings.length,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            return ListingItem(
              listing: listings[index],
            );
          },
        );
      },
      error: (error, stackTrace) {
        Sentry.captureException(error, stackTrace: stackTrace);
        return const Text('Something went wrong');
      },
      loading: () {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SkeletonRow(),
        );
      },
    );
  }
}
