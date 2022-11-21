import 'package:d_reader_flutter/core/providers/tab_bar_provider.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_sliver_tab_persisent_header.dart';
import 'package:d_reader_flutter/ui/widgets/common/search_bar_sliver.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/comics_tab.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/creators_tab.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/issues_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DiscoverTabViewEnum { comics, issues, creators }

class DiscoverView extends ConsumerWidget {
  const DiscoverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      initialIndex: ref.read(tabBarProvider).initialIndex,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            const SearchBarSliver(),
            const CustomSliverTabPersistentHeader(
              tabs: [
                Tab(
                  child: Text(
                    'Comics',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Issues',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Creators',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ];
        },
        body: const TabBarView(
          children: [
            DiscoverComicsTab(),
            DiscoverIssuesTab(),
            DiscoverCreatorsTab(),
          ],
        ),
      ),
    );
  }
}
