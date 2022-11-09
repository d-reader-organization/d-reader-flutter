import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      onTap: (value) {
        ref.read(scaffoldProvider.notifier).setNavigationIndex(value);
        ref.read(scaffoldPageController).animateToPage(
              value,
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 250),
            );
      },
      currentIndex: ref.watch(scaffoldProvider).navigationIndex,
      selectedItemColor: dReaderYellow,
      unselectedItemColor: Colors.white,
      backgroundColor: dReaderBlack,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_outline),
          label: 'Comics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_outline),
          label: 'Creators',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_outline),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_outline),
          label: 'Marketplace',
        ),
      ],
    );
  }
}
