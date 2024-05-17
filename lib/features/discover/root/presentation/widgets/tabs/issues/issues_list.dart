import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/cards/skeleton_card.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/issues/issues_list_builder.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/carrot_error_widget.dart';
import 'package:flutter/material.dart';

class IssuesList extends StatelessWidget {
  final PaginationState<ComicIssueModel> provider;
  const IssuesList({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return provider.when(
      data: (issues) {
        return IssuesListBuilder(issues: issues);
      },
      error: (err, stack) {
        return const CarrotErrorWidget(
          mainErrorText: 'We ran into some issues',
          adviceText: 'We are working on a fix. Thanks for your patience!',
        );
      },
      loading: () => ListView.separated(
        itemCount: 3,
        shrinkWrap: true,
        physics: const PageScrollPhysics(),
        itemBuilder: (context, index) {
          return const IssueListItemSkeleton();
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            color: ColorPalette.greyscale400,
            thickness: 1,
          );
        },
      ),
      onGoingError: (List<ComicIssueModel> items, Object? e, StackTrace? stk) {
        return IssuesListBuilder(
          issues: items,
        );
      },
      onGoingLoading: (List<ComicIssueModel> items) {
        return IssuesListBuilder(
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 4,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const SkeletonCard(
                    height: 165,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          const Expanded(
            flex: 2,
            child: SkeletonCard(
              height: 165,
            ),
          ),
        ],
      ),
    );
  }
}
