import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/views/discover.dart';
import 'package:d_reader_flutter/ui/views/home.dart';
import 'package:d_reader_flutter/ui/views/library.dart';
import 'package:d_reader_flutter/ui/views/settings/root.dart';
import 'package:d_reader_flutter/ui/widgets/beta_access_wrapper.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_bottom_navigation_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/test_mode_widget.dart';
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

  _appBar({
    required int navigationIndex,
    bool isDevnet = false,
  }) {
    switch (navigationIndex) {
      case 0:
      case 2:
        return PreferredSize(
          preferredSize: Size(0, isDevnet ? 90 : 64),
          child: Column(
            children: [
              const TestModeWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: CustomAppBar(
                  showSearchIcon: showSearchIcon,
                ),
              ),
            ],
          ),
        );
      case 1:
        return isDevnet
            ? const PreferredSize(
                preferredSize: Size(0, 64),
                child: TestModeWidget(),
              )
            : null;
      case 3:
        return PreferredSize(
          preferredSize: Size(0, isDevnet ? 90 : 56),
          child: Column(
            children: [
              const TestModeWidget(),
              AppBar(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                leadingWidth: 32,
              ),
            ],
          ),
        );
    }
  }

  EdgeInsets _bodyPadding(int screenIndex) {
    if (screenIndex == 0) {
      return EdgeInsets.zero;
    } else if (screenIndex == 3) {
      return const EdgeInsets.symmetric(horizontal: 12);
    }
    return const EdgeInsets.only(left: 12.0, right: 12, top: 8.0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorPalette.appBackgroundColor,
          appBar: _appBar(
            navigationIndex: ref.watch(scaffoldProvider).navigationIndex,
            isDevnet: ref.watch(environmentProvider).solanaCluster ==
                SolanaCluster.devnet.value,
          ),
          body: Padding(
            padding: _bodyPadding(ref.watch(scaffoldProvider).navigationIndex),
            child: body ??
                PageView(
                  controller: ref.watch(scaffoldPageController),
                  onPageChanged: (index) {
                    ref
                        .read(scaffoldProvider.notifier)
                        .setNavigationIndex(index);
                  },
                  children: const [
                    BetaAccessWrapper(
                      child: HomeView(),
                    ),
                    BetaAccessWrapper(
                      child: DiscoverView(),
                    ),
                    LibraryView(),
                    SettingsRootView(),
                  ],
                ),
          ),
          extendBody: false,
          extendBodyBehindAppBar:
              ref.watch(scaffoldProvider).navigationIndex == 0 ? true : false,
          bottomNavigationBar:
              showBottomNavigation ? const CustomBottomNavigationBar() : null,
        ),
      ),
    );
  }
}
