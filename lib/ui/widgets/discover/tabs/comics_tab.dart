import 'package:flutter/material.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/core/providers/search_provider.dart';
import 'package:d_reader_flutter/ui/widgets/discover/common/no_more_items.dart';
import 'package:d_reader_flutter/ui/widgets/discover/common/on_going_bottom.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/comics/comics_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiscoverComicsTab extends ConsumerWidget {
  DiscoverComicsTab({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String search = ref.watch(searchProvider).search;
    final String query = 'nameSubstring=$search';
    final provider = ref.watch(
      paginatedComicsProvider(query),
    );

    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.width * 0.2;

      if (maxScroll - currentScroll <= delta) {
        ref.read(paginatedComicsProvider(query).notifier).fetchNext();
      }
    });

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (context, index) {
              return ComicList(provider: provider);
            },
          ),
        ),
        OnGoingBottomWidget(provider: provider),
        NoMoreItemsWidget(
          listenableProvider: paginatedComicsProvider,
          query: query,
        ),
      ],
    );
  }
}
