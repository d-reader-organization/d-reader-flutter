import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/cards/comic_issue_card.dart';
import 'package:flutter/material.dart';

class IssuesGalleryBuilder extends StatelessWidget {
  final List<ComicIssueModel> issues;
  const IssuesGalleryBuilder({
    super.key,
    required this.issues,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.sizeOf(context).width > 600;
    return GridView.builder(
      itemCount: issues.length,
      primary: false,
      padding: const EdgeInsets.only(
        left: 4,
        top: 8,
      ),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 156 / 226,
      ),
      itemBuilder: (context, index) {
        return ComicIssueCard(
          issue: issues[index],
        );
      },
    );
  }
}
