import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/domain/providers/pagination_notifier.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/tabs/collectibles/wrapper.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/tabs/comics/wrapper.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/tabs/issues/wrapper.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/common/on_going_bottom.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreatorNotificationListener extends ConsumerWidget {
  final StateNotifierProviderFamily<PaginationNotifier, PaginationState,
      String?> listenableProvider;
  final String query;
  final ScrollListType scrollListType;
  const CreatorNotificationListener({
    super.key,
    required this.listenableProvider,
    required this.query,
    required this.scrollListType,
  });

  getListSliver(WidgetRef ref) {
    switch (scrollListType) {
      case ScrollListType.comicList:
        return CreatorComicsWrapper(
          provider: ref.read(
            paginatedComicsProvider(
              query,
            ),
          ),
        );
      case ScrollListType.issueList:
        return CreatorIssuesWrapper(
          provider: ref.read(
            paginatedIssuesProvider(
              query,
            ),
          ),
        );
      case ScrollListType.creatorList:
        return CreatorComicsWrapper(
          provider: ref.read(
            paginatedComicsProvider(
              query,
            ),
          ),
        );
      case ScrollListType.collectiblesList:
        return CreatorCollectiblesWrapper(
          provider: ref.read(
            paginatedComicsProvider(
              query,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(listenableProvider(query));
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollNotification) {
          double maxScroll = notification.metrics.maxScrollExtent;
          double currentScroll = notification.metrics.pixels;
          double delta = MediaQuery.sizeOf(context).width * 0.1;
          if (maxScroll - currentScroll <= delta) {
            ref.read(listenableProvider(query).notifier).fetchNext();
          }
        }
        return true;
      },
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (context, index) {
                return getListSliver(ref);
              },
            ),
          ),
          OnGoingBottomWidget(provider: provider),
        ],
      ),
    );
  }
}
