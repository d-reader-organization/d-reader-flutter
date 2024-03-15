import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/common/discover_scroll_view.dart';
import 'package:flutter/material.dart';

class DiscoverIssuesTab extends StatelessWidget {
  const DiscoverIssuesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DiscoverScrollView(
      listenableProvider: paginatedIssuesProvider,
      scrollListType: ScrollListType.issueList,
    );
  }
}
