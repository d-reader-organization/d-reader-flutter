import 'package:d_reader_flutter/ui/widgets/common/layout/custom_sliver_app_bar_delegate.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_sliver_tab_bar.dart';
import 'package:flutter/material.dart';

class CustomSliverTabPersistentHeader extends StatelessWidget {
  final List<Tab> tabs;
  const CustomSliverTabPersistentHeader({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomSliverAppBarDelegate(
        minHeight: 60,
        maxHeight: 60,
        child: CustomSliverTabBar(
          children: tabs,
        ),
      ),
    );
  }
}
