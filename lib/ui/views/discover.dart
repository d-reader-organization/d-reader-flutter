import 'package:d_reader_flutter/core/providers/tab_bar_provider.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_sliver_tab_persisent_header.dart';
import 'package:d_reader_flutter/ui/widgets/common/minting_progress.dart';
import 'package:d_reader_flutter/ui/widgets/common/search_bar_sliver.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/comics/comics_tab.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/creators/creators_tab.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/issues/issues_tab.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum DiscoverTabViewEnum { comics, issues, creators }

class DiscoverView extends ConsumerStatefulWidget {
  const DiscoverView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends ConsumerState<DiscoverView>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(
        length: 3,
        vsync: this,
        initialIndex: ref.read(tabBarProvider).selectedTabIndex);
    _controller.addListener(() {
      ref.read(tabBarProvider.notifier).setTabIndex(_controller.index);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: ref.read(tabBarProvider).selectedTabIndex,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            const SliverToBoxAdapter(
              child: MintingProgressWidget(),
            ),
            const SearchBarSliver(),
            CustomSliverTabPersistentHeader(
              controller: _controller,
              tabs: const [
                Tab(
                  text: 'Comics',
                ),
                Tab(
                  text: 'Issues',
                ),
                Tab(
                  text: 'Creators',
                ),
              ],
            ),
          ];
        },
        body: TabBarView(
          controller: _controller,
          children: const [
            DiscoverComicsTab(),
            DiscoverIssuesTab(),
            DiscoverCreatorsTab(),
          ],
        ),
      ),
    );
  }
}
