import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/cards/comic_issue_card_large.dart';
import 'package:flutter/material.dart';

class IssuesListBuilder extends StatelessWidget {
  final List<ComicIssueModel> issues;

  const IssuesListBuilder({
    super.key,
    required this.issues,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: issues.length,
      shrinkWrap: true,
      physics: const PageScrollPhysics(),
      itemBuilder: (context, index) {
        return ComicIssueCardLarge(
          issue: issues[index],
        );
      },
    );
  }
}
