import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/ui/widgets/discover/common/discover_scroll_view.dart';
import 'package:flutter/material.dart';

class DiscoverIssuesTab extends StatelessWidget {
  const DiscoverIssuesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DiscoverScrollView(
      listenableProvider: paginatedIssuesProvider,
      scrollListType: ScrollListType.issueList,
    );
  }
}
