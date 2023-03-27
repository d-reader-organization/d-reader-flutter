import 'package:d_reader_flutter/core/notifiers/pagination_notifier.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/core/providers/creator_provider.dart';
import 'package:d_reader_flutter/core/providers/search_provider.dart';
import 'package:d_reader_flutter/core/states/pagination_state.dart';
import 'package:d_reader_flutter/ui/widgets/discover/common/no_more_items.dart';
import 'package:d_reader_flutter/ui/widgets/discover/common/on_going_bottom.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/comics/comics_list.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/creators/creators_list.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/issues/issues_list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ScrollListType {
  comicList,
  issueList,
  creatorList,
}

class DiscoverScrollView extends ConsumerStatefulWidget {
  final StateNotifierProviderFamily<PaginationNotifier, PaginationState,
      String?> listenableProvider;
  final ScrollListType scrollListType;

  const DiscoverScrollView({
    super.key,
    required this.listenableProvider,
    required this.scrollListType,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DiscoverScrollViewState();
}

class _DiscoverScrollViewState extends ConsumerState<DiscoverScrollView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getListSliver(String query) {
    switch (widget.scrollListType) {
      case ScrollListType.comicList:
        return ComicList(
          provider: ref.read(
            paginatedComicsProvider(
              query,
            ),
          ),
        );
      case ScrollListType.issueList:
        return IssuesList(
          provider: ref.read(
            paginatedIssuesProvider(
              query,
            ),
          ),
        );
      case ScrollListType.creatorList:
        return CreatorsList(
          provider: ref.read(
            paginatedCreatorsProvider(
              query,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    String search = ref.watch(searchProvider).search;
    final String query = 'nameSubstring=$search';
    final provider = ref.watch(
      widget.listenableProvider(query),
    );

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.width * 0.2;

      if (maxScroll - currentScroll <= delta) {
        ref.read(widget.listenableProvider(query).notifier).fetchNext();
      }
    });

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          // figure out
          delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (context, index) {
              return getListSliver(query);
            },
          ),
        ),
        OnGoingBottomWidget(provider: provider),
        NoMoreItemsWidget(
          listenableProvider: widget.listenableProvider,
          query: query,
        ),
      ],
    );
  }
}
