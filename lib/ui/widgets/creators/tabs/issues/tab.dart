import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:d_reader_flutter/ui/widgets/creators/tabs/common/creator_notification_listener.dart';
import 'package:flutter/material.dart';

class CreatorIssuesTab extends StatelessWidget {
  final String creatorSlug;
  const CreatorIssuesTab({
    super.key,
    required this.creatorSlug,
  });

  @override
  Widget build(BuildContext context) {
    return CreatorNotificationListener(
      listenableProvider: paginatedIssuesProvider,
      query: 'creatorSlug=$creatorSlug',
      scrollListType: ScrollListType.issueList,
    );
  }
}
