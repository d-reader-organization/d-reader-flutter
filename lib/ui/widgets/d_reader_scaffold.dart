import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/views/discover.dart';
import 'package:d_reader_flutter/ui/views/home.dart';
import 'package:d_reader_flutter/ui/views/library.dart';
import 'package:d_reader_flutter/ui/views/marketplace.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DReaderScaffold extends ConsumerWidget {
  const DReaderScaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ColorPalette.appBackgroundColor,
        appBar: ref.watch(scaffoldProvider).navigationIndex != 1
            ? const PreferredSize(
                preferredSize: Size(0, 64),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomAppBar(),
                ),
              )
            : null,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: PageView(
            controller: ref.watch(scaffoldPageController),
            onPageChanged: (index) {
              ref.read(scaffoldProvider.notifier).setNavigationIndex(index);
            },
            children: const [
              HomeView(),
              DiscoverView(),
              LibraryView(),
              MarketPlaceView(),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
