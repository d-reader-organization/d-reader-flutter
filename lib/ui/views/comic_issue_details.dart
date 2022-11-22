import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_card_for_sale.dart';
import 'package:d_reader_flutter/ui/widgets/details_scaffold.dart';
import 'package:flutter/material.dart';

class ComicIssueDetails extends StatelessWidget {
  final String slug;
  const ComicIssueDetails({
    Key? key,
    required this.slug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DetailsScaffold(
      showAwardText: false,
      body: GridView.builder(
        itemCount: 5,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          mainAxisExtent: 198,
        ),
        itemBuilder: (context, index) {
          return ComicCardForSale(issue: ComicIssueModel.fromJson({}));
        },
      ),
    );
  }
}
