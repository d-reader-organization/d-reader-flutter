import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/core/providers/discover/view_mode.dart';
import 'package:d_reader_flutter/core/providers/search_provider.dart';
import 'package:d_reader_flutter/core/providers/tab_bar_provider.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/shared/styles.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/filter_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_sliver_app_bar_delegate.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_sliver_tab_bar.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/comics/comics_tab.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/creators/creators_tab.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/issues/issues_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum DiscoverTabViewEnum { comics, issues, creators }

class DiscoverView extends ConsumerStatefulWidget {
  const DiscoverView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends ConsumerState<DiscoverView>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(
        length: 3,
        vsync: this,
        initialIndex: ref.read(tabBarProvider).selectedTabIndex);
    _controller.addListener(() {
      ref.read(tabBarProvider.notifier).setTabIndex(_controller.index);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _updateViewMode() async {
    final viewMode = ref.read(viewModeProvider) == ViewMode.detailed
        ? ViewMode.gallery
        : ViewMode.detailed;

    ref.read(viewModeProvider.notifier).update((state) => viewMode);
    await LocalStore.instance.put(
      viewModeStoreKey,
      viewMode.name,
    );
  }

  void _submitHandler(WidgetRef ref) {
    String search = ref.read(searchProvider).searchController.text.trim();
    ref.read(searchProvider.notifier).updateSearchValue(search);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: ref.read(tabBarProvider).selectedTabIndex,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Discover',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _updateViewMode();
                      },
                      child: ref.watch(viewModeProvider) == ViewMode.detailed
                          ? SvgPicture.asset('assets/icons/category.svg')
                          : SvgPicture.asset('assets/icons/list.svg'),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: CustomSliverAppBarDelegate(
                minHeight: 116,
                maxHeight: 116,
                child: Container(
                  color: ColorPalette.appBackgroundColor,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: ref.read(searchProvider).searchController,
                        textInputAction: TextInputAction.search,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        decoration: searchInputDecoration(
                          hintText: 'Search comics, issues & genres',
                          prefixIcon: IconButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _submitHandler(ref);
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/search.svg',
                              colorFilter: const ColorFilter.mode(
                                ColorPalette.dReaderGrey,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          suffixIcon: const FilterIcon(),
                        ),
                        onFieldSubmitted: (value) {
                          _submitHandler(ref);
                        },
                      ),
                      CustomSliverTabBar(
                        controller: _controller,
                        children: const [
                          Tab(
                            text: 'Comics',
                          ),
                          Tab(
                            text: 'Issues',
                          ),
                          Tab(
                            text: 'Creators',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _controller,
          children: const [
            DiscoverComicsTab(),
            DiscoverIssuesTab(),
            DiscoverCreatorsTab(),
          ],
        ),
      ),
    );
  }
}
