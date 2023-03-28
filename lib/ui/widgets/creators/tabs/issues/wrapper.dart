import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/states/pagination_state.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/creators/tabs/issues/list_builder.dart';
import 'package:flutter/material.dart';

class CreatorIssuesWrapper extends StatelessWidget {
  final PaginationState<ComicIssueModel> provider;
  const CreatorIssuesWrapper({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return provider.when(
      data: (issues) {
        return IssuesListBuilder(
          issues: issues,
        );
      },
      loading: () => ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        physics: const PageScrollPhysics(),
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: SkeletonCard(),
        ),
      ),
      error: (err, stack) {
        return Text(
          '$err',
          style: const TextStyle(color: ColorPalette.dReaderRed),
        );
      },
      onGoingLoading: (items) {
        return IssuesListBuilder(issues: items);
      },
      onGoingError: (items, err, stk) {
        return IssuesListBuilder(issues: items);
      },
    );
  }
}
