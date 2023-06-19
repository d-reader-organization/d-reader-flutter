import 'package:d_reader_flutter/core/providers/search_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomSliverTabBar extends ConsumerWidget with PreferredSizeWidget {
  final List<Widget> children;
  final TabController? controller;
  const CustomSliverTabBar({
    Key? key,
    required this.children,
    this.controller,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                    color: ColorPalette.boxBackground300, width: 2.0),
              ),
            ),
          ),
          TabBar(
            onTap: (int index) {
              ref.read(searchProvider.notifier).updateSearchValue('');
              ref.read(searchProvider).searchController.clear();
            },
            tabs: children,
            controller: controller,
            indicatorWeight: 4,
            indicatorColor: ColorPalette.dReaderYellow100,
            labelColor: ColorPalette.dReaderYellow100,
            unselectedLabelColor: ColorPalette.dReaderGrey,
          ),
        ],
      ),
    );
  }
}
