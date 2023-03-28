import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:d_reader_flutter/ui/widgets/creators/tabs/common/creator_notification_listener.dart';
import 'package:flutter/material.dart';

class CreatorComicsTab extends StatelessWidget {
  final String creatorSlug;
  const CreatorComicsTab({
    super.key,
    required this.creatorSlug,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return CreatorNotificationListener(
      listenableProvider: paginatedComicsProvider,
      query: 'creatorSlug=$creatorSlug',
      scrollListType: ScrollListType.comicList,
    );
  }
}
