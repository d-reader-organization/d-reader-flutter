import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/views/comics.dart';
import 'package:d_reader_flutter/ui/views/creators.dart';
import 'package:d_reader_flutter/ui/views/home.dart';
import 'package:d_reader_flutter/ui/views/library.dart';
import 'package:d_reader_flutter/ui/views/marketplace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DReaderScaffold extends ConsumerWidget {
  const DReaderScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: dReaderBlack,
        appBar: PreferredSize(
          preferredSize: const Size(0, 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: AppBar(
              leading: Container(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  Config.logoTextPath,
                ),
              ),
              leadingWidth: 164,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              actions: const [
                Icon(
                  Icons.notifications_none,
                ),
                SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.person_outline,
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: PageView(
            controller: ref.watch(scaffoldPageController),
            children: const [
              HomeView(),
              ComicsView(),
              CreatorsView(),
              LibraryView(),
              MarketplaceView(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
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
        ),
      ),
    );
  }
}
