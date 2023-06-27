import 'dart:ui';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/bottom_navigation_item_icon.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

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
          child: BottomNavigationBar(
            onTap: (value) {
              ref.read(scaffoldPageController).animateToPage(
                    value,
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 5),
                  );
            },
            currentIndex: ref.watch(scaffoldProvider).navigationIndex,
            selectedItemColor: ColorPalette.dReaderYellow100,
            unselectedItemColor: Colors.white,
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: BottomNavigationItemIcon(
                    imagePath: 'assets/icons/home.svg'),
                label: 'Home',
                activeIcon: BottomNavigationItemIcon(
                  imagePath: 'assets/icons/home_bold.svg',
                  isActive: true,
                ),
              ),
              BottomNavigationBarItem(
                icon: BottomNavigationItemIcon(
                    imagePath: 'assets/icons/discovery.svg'),
                label: 'Discover',
                activeIcon: BottomNavigationItemIcon(
                  imagePath: 'assets/icons/discovery_bold.svg',
                  isActive: true,
                ),
              ),
              BottomNavigationBarItem(
                icon: BottomNavigationItemIcon(
                    imagePath: 'assets/icons/bookmark.svg'),
                label: 'Library',
                activeIcon: BottomNavigationItemIcon(
                  imagePath: 'assets/icons/bookmark_bold.svg',
                  isActive: true,
                ),
              ),
              BottomNavigationBarItem(
                icon: BottomNavigationItemIcon(
                    imagePath:
                        '${Config.settingsAssetsPath}/light/setting.svg'),
                label: 'Settings',
                activeIcon: BottomNavigationItemIcon(
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
