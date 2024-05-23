import 'dart:ui';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/scaffold_provider.dart';
import 'package:d_reader_flutter/shared/widgets/layout/bottom_navigation_item_icon.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(
          16,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 48, sigmaX: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: NavigationBar(
            onDestinationSelected: (value) {
              ref.read(scaffoldPageController).animateToPage(
                    value,
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 5),
                  );
            },
            selectedIndex: ref.watch(scaffoldNavigationIndexProvider),
            backgroundColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            elevation: 0,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            destinations: const [
              NavigationDestination(
                icon: BottomNavigationItemIcon(
                  imagePath: 'assets/icons/home.svg',
                ),
                label: 'Home',
                selectedIcon: BottomNavigationItemIcon(
                  imagePath: 'assets/icons/home_bold.svg',
                  isActive: true,
                ),
              ),
              NavigationDestination(
                icon: BottomNavigationItemIcon(
                  imagePath: 'assets/icons/discovery.svg',
                ),
                label: 'Discover',
                selectedIcon: BottomNavigationItemIcon(
                  imagePath: 'assets/icons/discovery_bold.svg',
                  isActive: true,
                ),
              ),
              NavigationDestination(
                icon: BottomNavigationItemIcon(
                  imagePath: 'assets/icons/bookmark.svg',
                ),
                label: 'Library',
                selectedIcon: BottomNavigationItemIcon(
                  imagePath: 'assets/icons/bookmark_bold.svg',
                  isActive: true,
                ),
              ),
              NavigationDestination(
                icon: BottomNavigationItemIcon(
                  imagePath: '${Config.settingsAssetsPath}/light/setting.svg',
                ),
                label: 'Settings',
                selectedIcon: BottomNavigationItemIcon(
                  imagePath: '${Config.settingsAssetsPath}/bold/setting.svg',
                  isActive: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
