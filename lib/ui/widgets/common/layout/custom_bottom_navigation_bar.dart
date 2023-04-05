import 'dart:ui';

import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        filter: ImageFilter.blur(sigmaY: 32, sigmaX: 32),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
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
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedItemColor: Colors.white,
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/home.svg'),
                label: 'Home',
                activeIcon: SvgPicture.asset(
                  'assets/icons/home_bold.svg',
                  colorFilter: const ColorFilter.mode(
                    ColorPalette.dReaderYellow100,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/discovery.svg'),
                label: 'Discover',
                activeIcon: SvgPicture.asset(
                  'assets/icons/discovery_bold.svg',
                  colorFilter: const ColorFilter.mode(
                    ColorPalette.dReaderYellow100,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/bookmark.svg'),
                label: 'Library',
                activeIcon: SvgPicture.asset(
                  'assets/icons/bookmark_bold.svg',
                  colorFilter: const ColorFilter.mode(
                    ColorPalette.dReaderYellow100,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/profile.svg'),
                label: 'Settings',
                activeIcon: SvgPicture.asset(
                  'assets/icons/profile_bold.svg',
                  colorFilter: const ColorFilter.mode(
                    ColorPalette.dReaderYellow100,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
