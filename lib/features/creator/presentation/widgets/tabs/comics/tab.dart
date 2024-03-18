import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/tabs/common/creator_notification_listener.dart';
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
