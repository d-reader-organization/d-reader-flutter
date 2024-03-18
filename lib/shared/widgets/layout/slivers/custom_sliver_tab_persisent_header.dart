import 'package:d_reader_flutter/shared/widgets/layout/slivers/custom_sliver_app_bar_delegate.dart';
import 'package:d_reader_flutter/shared/widgets/layout/slivers/custom_sliver_tab_bar.dart';
import 'package:flutter/material.dart';

class CustomSliverTabPersistentHeader extends StatelessWidget {
  final List<Tab> tabs;
  final TabController? controller;
  final EdgeInsets? padding;

  const CustomSliverTabPersistentHeader({
    super.key,
    required this.tabs,
    this.controller,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomSliverAppBarDelegate(
        minHeight: 60,
        maxHeight: 60,
        child: CustomSliverTabBar(
          controller: controller,
          padding: padding,
          children: tabs,
        ),
      ),
    );
  }
}
