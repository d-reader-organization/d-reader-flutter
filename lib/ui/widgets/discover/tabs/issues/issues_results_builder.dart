import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/discover/comic_issue_card.dart';
import 'package:flutter/material.dart';

class IssuesResultsBuilder extends StatelessWidget {
  final List<ComicIssueModel> issues;
  const IssuesResultsBuilder({
    super.key,
    required this.issues,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: issues.length,
      shrinkWrap: true,
      physics: const PageScrollPhysics(),
      itemBuilder: (context, index) {
        return DiscoverComicIssueCard(
          issue: issues[index],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: ColorPalette.boxBackground300,
          thickness: 1,
        );
      },
    );
  }
}
