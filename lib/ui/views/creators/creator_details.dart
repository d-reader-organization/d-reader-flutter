import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/custom_sliver_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/creators/comics.dart';
import 'package:d_reader_flutter/ui/widgets/creators/creator_tab_bar.dart';
import 'package:d_reader_flutter/ui/widgets/creators/header_sliver_list.dart';
import 'package:flutter/material.dart';

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

class CreatorDetailsView extends StatelessWidget {
  const CreatorDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dReaderBlack,
      body: SafeArea(
        child: Stack(
          children: [
            DefaultTabController(
              length: 3,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    const CustomSliverAppBar(),
                    const HeaderSliverList(),
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
                body: const TabBarView(
                  children: [
                    CreatorComicsTab(),
                    Center(
                      child: Text(
                        'Hey ya',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Hey ya',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
