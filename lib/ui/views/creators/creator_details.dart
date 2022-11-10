import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/providers/creator_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_sliver_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/creators/header_sliver_list.dart';
import 'package:d_reader_flutter/ui/widgets/creators/tab_bar.dart';
import 'package:d_reader_flutter/ui/widgets/creators/tabs/collectibles_tab.dart';
import 'package:d_reader_flutter/ui/widgets/creators/tabs/comics_tab.dart';
import 'package:d_reader_flutter/ui/widgets/creators/tabs/issues_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight > minHeight ? maxHeight : minHeight;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class CreatorDetailsView extends ConsumerWidget {
  final String slug;
  const CreatorDetailsView({
    Key? key,
    required this.slug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(slug);
    AsyncValue<CreatorModel> creator = ref.watch(creatorProvider(slug));
    return Scaffold(
      backgroundColor: dReaderBlack,
      body: SafeArea(
          child: creator.when(
        data: (data) {
          return Stack(
            children: [
              DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      const CustomSliverAppBar(),
                      HeaderSliverList(creator: data),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                          minHeight: 50,
                          maxHeight: 50,
                          child: const CreatorTabBar(
                            children: [
                              Tab(
                                child: Text(
                                  'Comics',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Tab(
                                child: Text('Issues',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              Tab(
                                child: Text('Collectables',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      CreatorComicsTab(
                        comics: data.comics,
                      ),
                      CreatorIssuesTab(issues: data.issues),
                      CollectiblesTab(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        error: (err, stack) {
          print(stack);
          return Text(
            'Error: $err',
            style: const TextStyle(color: Colors.red),
          );
        },
        loading: () => const SizedBox(
          height: 400,
          child: SkeletonCard(),
        ),
      )),
    );
  }
}
