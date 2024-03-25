import 'package:d_reader_flutter/shared/presentations/providers/common/search_provider.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomSliverTabBar extends ConsumerWidget implements PreferredSizeWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final EdgeInsets? padding;
  const CustomSliverTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: padding,
      margin: const EdgeInsets.only(bottom: 16),
      color: ColorPalette.appBackgroundColor,
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ColorPalette.greyscale200,
                  width: 1,
                ),
              ),
            ),
          ),
          TabBar(
            onTap: (int index) {
              ref.read(searchProvider.notifier).updateSearchValue('');
              ref.read(searchProvider).searchController.clear();
            },
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: tabs,
            controller: controller,
            indicatorWeight: 4,
            labelStyle: Theme.of(context).textTheme.titleMedium,
            unselectedLabelStyle:
                Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
            indicatorColor: ColorPalette.dReaderYellow100,
            labelColor: ColorPalette.dReaderYellow100,
            unselectedLabelColor: ColorPalette.greyscale200,
          ),
        ],
      ),
    );
  }
}
