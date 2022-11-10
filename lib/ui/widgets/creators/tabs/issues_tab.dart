import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issue_card_large.dart';
import 'package:flutter/material.dart';

class CreatorIssuesTab extends StatelessWidget {
  const CreatorIssuesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return const ComicIssueCardLarge();
      },
    );
  }
}
