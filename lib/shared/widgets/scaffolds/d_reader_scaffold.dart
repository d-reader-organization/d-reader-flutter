import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/notification/notification_controller.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/scaffold_provider.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/screens/discover.dart';
import 'package:d_reader_flutter/features/home/presentation/screens/home.dart';
import 'package:d_reader_flutter/features/library/presentation/screens/library.dart';
import 'package:d_reader_flutter/features/settings/presentation/screens/root.dart';
import 'package:d_reader_flutter/shared/widgets/layout/custom_bottom_navigation_bar.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/test_mode_widget.dart';
import 'package:d_reader_flutter/features/settings/presentation/widgets/referrals/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DReaderScaffold extends ConsumerStatefulWidget {
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
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DReaderScaffoldState();
}

class _DReaderScaffoldState extends ConsumerState<DReaderScaffold> {
  @override
  void initState() {
    super.initState();
    initNotifications();
  }

  Future<void> initNotifications() async {
    await ref.read(notificationControllerProvider.notifier).init();
  }

  _appBar({
    required int navigationIndex,
    bool isDevnet = false,
  }) {
    switch (navigationIndex) {
      case 0:
      case 1:
      case 2:
        return isDevnet
            ? const PreferredSize(
                preferredSize: Size(0, 56),
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
                toolbarHeight: 48,
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  EdgeInsets _bodyPadding({
    required int screenIndex,
    bool hasBetaAccess = false,
  }) {
    if (screenIndex == 0) {
      return EdgeInsets.zero;
    } else if (screenIndex == 3) {
      return const EdgeInsets.symmetric(horizontal: 12);
    }
    return hasBetaAccess
        ? const EdgeInsets.only(left: 12.0, right: 12, top: 8.0)
        : EdgeInsets.zero;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorPalette.appBackgroundColor,
          appBar: _appBar(
            navigationIndex: ref.watch(scaffoldNavigationIndexProvider),
            isDevnet: ref.watch(environmentProvider).solanaCluster ==
                SolanaCluster.devnet.value,
          ),
          body: Padding(
            padding: _bodyPadding(
              screenIndex: ref.watch(scaffoldNavigationIndexProvider),
              hasBetaAccess: ref.watch(environmentProvider).user != null &&
                  ref.watch(environmentProvider).user!.hasBetaAccess,
            ),
            child: widget.body ??
                PageView(
                  controller: ref.watch(scaffoldPageController),
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    ref
                        .read(scaffoldNavigationIndexProvider.notifier)
                        .update((state) => index);
                  },
                  children: const [
                    HomeView(),
                    DiscoverView(),
                    NewLibraryView(),
                    SettingsRootView(),
                  ],
                ),
          ),
          extendBody: false,
          bottomNavigationBar: widget.showBottomNavigation
              ? const CustomBottomNavigationBar()
              : null,
        ),
      ),
    );
  }
}

class BetaBottomNavigation extends ConsumerWidget {
  final Widget child;
  const BetaBottomNavigation({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(environmentProvider).user?.hasBetaAccess != null &&
            !ref.watch(environmentProvider).user!.hasBetaAccess
        ? const ReferralBottomNavigation()
        : child;
  }
}
