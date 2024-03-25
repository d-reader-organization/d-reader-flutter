import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/creator/presentation/providers/creator_providers.dart';
import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/utils/utils.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/pagination_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/common/no_more_items.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/common/on_going_bottom.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/comics/comics_gallery.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/comics/comics_list.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/creators/creators_gallery.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/creators/creators_list.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/issues/issues_gallery.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/issues/issues_list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiscoverScrollView extends ConsumerWidget {
  final StateNotifierProviderFamily<PaginationNotifier, PaginationState,
      String?> listenableProvider;
  final ScrollListType scrollListType;

  const DiscoverScrollView({
    super.key,
    required this.listenableProvider,
    required this.scrollListType,
  });

  getListSliver({
    required String query,
    required bool isDetailedView,
    required WidgetRef ref,
  }) {
    switch (scrollListType) {
      case ScrollListType.comicList:
        return isDetailedView
            ? ComicList(
                provider: ref.read(
                  paginatedComicsProvider(
                    query,
                  ),
                ),
              )
            : ComicGallery(
                provider: ref.read(
                  paginatedComicsProvider(
                    query,
                  ),
                ),
              );
      case ScrollListType.issueList:
        return isDetailedView
            ? IssuesList(
                provider: ref.read(
                  paginatedIssuesProvider(
                    query,
                  ),
                ),
              )
            : IssuesGallery(
                provider: ref.read(
                  paginatedIssuesProvider(
                    query,
                  ),
                ),
              );
      case ScrollListType.creatorList:
        return isDetailedView
            ? CreatorsList(
                provider: ref.read(
                  paginatedCreatorsProvider(
                    query,
                  ),
                ),
              )
            : CreatorsGallery(
                provider: ref.read(
                  paginatedCreatorsProvider(
                    query,
                  ),
                ),
              );
      case ScrollListType.collectiblesList:
        return ComicList(
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
    final String query = getFilterQueryString(ref, scrollListType);
    final provider = ref.watch(
      listenableProvider(
        query,
      ),
    );
    final bool isDetailedView =
        ref.watch(viewModeProvider) == ViewMode.detailed;

    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollNotification) {
          double maxScroll = notification.metrics.maxScrollExtent;
          double currentScroll = notification.metrics.pixels;
          double delta = MediaQuery.sizeOf(context).width * 0.2;
          if (maxScroll - currentScroll <= delta) {
            ref.read(listenableProvider(query).notifier).fetchNext();
          }
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          if (scrollListType == ScrollListType.comicList) {
            ref.invalidate(paginatedComicsProvider);
          } else if (scrollListType == ScrollListType.issueList) {
            ref.invalidate(paginatedIssuesProvider);
          }
          ref.invalidate(paginatedCreatorsProvider);
        },
        backgroundColor: ColorPalette.dReaderYellow100,
        color: ColorPalette.appBackgroundColor,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) {
                  return getListSliver(
                    query: query,
                    isDetailedView: isDetailedView,
                    ref: ref,
                  );
                },
              ),
            ),
            OnGoingBottomWidget(provider: provider),
            NoMoreItemsWidget(
              listenableProvider: listenableProvider,
              query: query,
            ),
          ],
        ),
      ),
    );
  }
}
