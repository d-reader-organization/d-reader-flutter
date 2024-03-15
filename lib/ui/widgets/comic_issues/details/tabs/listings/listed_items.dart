import 'package:d_reader_flutter/features/auction_house/domain/models/listing.dart';
import 'package:d_reader_flutter/features/auction_house/presentation/providers/listings_provider.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/tabs/listings/listed_item_row.dart';
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
    final provider = ref.watch(listingsPaginatedProvider(issue));
    return provider.when(
      data: (listings) {
        if (listings.isEmpty) {
          return const Text(
            'No items listed.',
            textAlign: TextAlign.center,
          );
        }
        return ListedItemsBuilder(listings: listings);
      },
      error: (error, stackTrace) {
        return const Text('Failed to fetch data');
      },
      loading: () {
        return const Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: ColorPalette.greyscale500,
            ),
          ),
        );
      },
      onGoingLoading: (List<ListingModel> listings) {
        return ListedItemsBuilder(listings: listings);
      },
      onGoingError: (listings, e, stk) {
        return ListedItemsBuilder(listings: listings);
      },
    );
  }
}

class ListedItemsBuilder extends StatelessWidget {
  final List<ListingModel> listings;
  const ListedItemsBuilder({
    super.key,
    required this.listings,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listings.length,
      padding: EdgeInsets.zero,
      physics: const PageScrollPhysics(),
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return ListingItem(
          listing: listings[index],
        );
      },
    );
  }
}
