import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issue_card.dart';
import 'package:flutter/material.dart';

class IssuesGalleryBuilder extends StatelessWidget {
  final List<ComicIssueModel> issues;
  const IssuesGalleryBuilder({
    super.key,
    required this.issues,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    bool isTablet = screenWidth > 600;
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
        mainAxisExtent: 217,
      ),
      itemBuilder: (context, index) {
        return ComicIssueCard(
          issue: issues[index],
        );
      },
    );
  }
}
