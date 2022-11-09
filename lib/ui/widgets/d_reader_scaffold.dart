import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/views/comics.dart';
import 'package:d_reader_flutter/ui/views/creators/creators.dart';
import 'package:d_reader_flutter/ui/views/home.dart';
import 'package:d_reader_flutter/ui/views/library.dart';
import 'package:d_reader_flutter/ui/views/marketplace.dart';
import 'package:d_reader_flutter/ui/widgets/common/custom_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DReaderScaffold extends ConsumerWidget {
  final Widget? body;
  const DReaderScaffold({
    Key? key,
    this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: dReaderBlack,
        appBar: const PreferredSize(
          preferredSize: Size(0, 64),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: CustomAppBar(),
          ),
        ),
        body: body ??
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
