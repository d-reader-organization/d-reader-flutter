import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_sliver_tab_persisent_header.dart';
import 'package:d_reader_flutter/ui/widgets/library/tabs/owned.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewLibraryView extends ConsumerStatefulWidget {
  const NewLibraryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NewLibraryViewState();
}

class NewLibraryViewState extends ConsumerState<NewLibraryView>
    with TickerProviderStateMixin {
  late final TabController _controller =
      TabController(length: 3, vsync: this, initialIndex: 1);

  @override
  void initState() {
    super.initState();
    ref.read(
      registerWalletToSocketEvents,
    );
    _controller.addListener(() {
      if (_controller.indexIsChanging && _controller.previousIndex == 1) {
        _controller.index = 1;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: NestedScrollView(
          body: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TabBarView(
              controller: _controller,
              children: const [
                Text('Coming soon'),
                OwnedListView(),
                Text('Coming soon'),
              ],
            ),
          ),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const SliverAppBar(
                leading: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Library',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     return;
                        //   },
                        //   child: SvgPicture.asset(
                        //     'assets/icons/search.svg',
                        //     width: 24,
                        //     height: 24,
                        //     colorFilter: const ColorFilter.mode(
                        //       Colors.white,
                        //       BlendMode.srcIn,
                        //     ),
                        //   ),
                        // ),
                      ]),
                ),
                leadingWidth: double.infinity,
                backgroundColor: ColorPalette.appBackgroundColor,
              ),
              CustomSliverTabPersistentHeader(
                controller: _controller,
                tabs: const [
                  Tab(
                    child: Text(
                      'Favorites',
                      style: TextStyle(
                        color: ColorPalette.boxBackground400,
                      ),
                    ),
                  ),
                  Tab(
                    text: 'Owned',
                  ),
                  Tab(
                    child: Text(
                      'Creators',
                      style: TextStyle(
                        color: ColorPalette.boxBackground400,
                      ),
                    ),
                  ),
                ],
              ),
            ];
          },
        ));
  }
}
