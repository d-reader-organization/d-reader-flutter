import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/views/discover.dart';
import 'package:d_reader_flutter/ui/views/home.dart';
import 'package:d_reader_flutter/ui/views/library.dart';
import 'package:d_reader_flutter/ui/views/marketplace.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DReaderScaffold extends ConsumerWidget {
  final Widget? body;
  final bool showBottomNavigation;
  final bool showSearchIcon;
  const DReaderScaffold({
    super.key,
    this.showBottomNavigation = true,
    this.showSearchIcon = false,
    this.body,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ColorPalette.appBackgroundColor,
        appBar: ref.watch(scaffoldProvider).navigationIndex != 1
            ? PreferredSize(
                preferredSize: const Size(0, 64),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomAppBar(
                    showSearchIcon: showSearchIcon,
                  ),
                ),
              )
            : null,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, top: 8.0),
            child: body ??
                PageView(
                  controller: ref.watch(scaffoldPageController),
                  onPageChanged: (index) {
                    ref
                        .read(scaffoldProvider.notifier)
                        .setNavigationIndex(index);
                  },
                  children: const [
                    HomeView(),
                    DiscoverView(),
                    LibraryView(),
                    MarketPlaceView(),
                  ],
                ),
          ),
        ),
        extendBody: true,
        bottomNavigationBar:
            showBottomNavigation ? const CustomBottomNavigationBar() : null,
      ),
    );
  }
}
