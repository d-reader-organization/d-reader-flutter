import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/states/pagination_state.dart';
import 'package:d_reader_flutter/ui/utils/home_cards_width.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/issues/issues_gallery_builder.dart';
import 'package:flutter/material.dart';

class IssuesGallery extends StatelessWidget {
  final PaginationState<ComicIssueModel> provider;
  const IssuesGallery({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return provider.when(
      data: (issues) {
        return IssuesGalleryBuilder(issues: issues);
      },
      error: (err, stack) => Text(
        'Error: $err',
        style: const TextStyle(color: Colors.red),
      ),
      loading: () => ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        itemBuilder: (context, index) => const IssueListItemSkeleton(),
      ),
      onGoingError: (List<ComicIssueModel> items, Object? e, StackTrace? stk) {
        return IssuesGalleryBuilder(
          issues: items,
        );
      },
      onGoingLoading: (List<ComicIssueModel> items) {
        return IssuesGalleryBuilder(
          issues: items,
        );
      },
    );
  }
}

class IssueListItemSkeleton extends StatelessWidget {
  const IssueListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 217,
      child: ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => SkeletonCard(
          height: 217,
          width: getCardWidth(MediaQuery.sizeOf(context).width),
        ),
      ),
    );
  }
}
