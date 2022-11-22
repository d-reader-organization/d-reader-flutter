import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issue_card_large.dart';
import 'package:d_reader_flutter/ui/widgets/details_scaffold.dart';
import 'package:flutter/material.dart';

class ComicDetails extends StatelessWidget {
  final String slug;
  const ComicDetails({
    Key? key,
    required this.slug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DetailsScaffold(
      showAwardText: true,
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ComicIssueCardLarge(
            issue: ComicIssueModel.fromJson({}),
          );
        },
      ),
    );
  }
}
