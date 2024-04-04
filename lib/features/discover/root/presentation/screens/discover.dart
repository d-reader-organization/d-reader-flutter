import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/presentations/providers/common/search_provider.dart';
import 'package:d_reader_flutter/shared/presentations/providers/common/tab_bar_provider.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/theme/decorations.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/filter/filter_icon.dart';
import 'package:d_reader_flutter/shared/widgets/layout/slivers/custom_sliver_tab_bar.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/comics/comics_tab.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/creators/creators_tab.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/issues/issues_tab.dart';
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
        length: 3, vsync: this, initialIndex: ref.read(tabBarProvider));
    _controller.addListener(() {
      ref.read(tabBarProvider.notifier).update((state) => _controller.index);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitHandler(WidgetRef ref) {
    ref.read(isSearchFocused.notifier).update((state) => false);
    String search = ref.read(searchProvider).searchController.text.trim();
    ref.read(searchProvider.notifier).updateSearchValue(search);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: ref.read(tabBarProvider),
      child: NestedScrollView(
        floatHeaderSlivers: true,
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discover',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final viewMode =
                            ref.read(viewModeProvider) == ViewMode.detailed
                                ? ViewMode.gallery
                                : ViewMode.detailed;

                        ref
                            .read(viewModeProvider.notifier)
                            .update((state) => viewMode);
                        await LocalStore.instance.put(
                          viewModeStoreKey,
                          viewMode.name,
                        );
                      },
                      child: ref.watch(viewModeProvider) == ViewMode.detailed
                          ? SvgPicture.asset('assets/icons/category.svg')
                          : SvgPicture.asset('assets/icons/list.svg'),
                    ),
                  ],
                ),
              ),
            ),
            SliverAppBar(
              backgroundColor: ColorPalette.appBackgroundColor,
              titleSpacing: 0,
              floating: true,
              toolbarHeight: 140,
              title: Column(
                children: [
                  TextFormField(
                    controller: ref.read(searchProvider).searchController,
                    textInputAction: TextInputAction.search,
                    cursorColor: Colors.white,
                    style: Theme.of(context).textTheme.bodyMedium,
                    onTap: () {
                      ref
                          .read(isSearchFocused.notifier)
                          .update((state) => true);
                    },
                    onTapOutside: (event) {
                      ref
                          .read(isSearchFocused.notifier)
                          .update((state) => false);
                    },
                    decoration: searchInputDecoration(
                      hintText: 'Search comics, issues & genres',
                      prefixIcon: IconButton(
                        onPressed: ref.watch(isSearchFocused)
                            ? () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                ref.invalidate(isSearchFocused);
                                ref.invalidate(searchProvider);
                              }
                            : null,
                        icon: ref.watch(isSearchFocused)
                            ? const Icon(
                                Icons.close,
                                size: 24,
                                color: Colors.white,
                              )
                            : SvgPicture.asset(
                                'assets/icons/search.svg',
                                colorFilter: const ColorFilter.mode(
                                  ColorPalette.greyscale200,
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
                  const SizedBox(
                    height: 16,
                  ),
                  CustomSliverTabBar(
                    controller: _controller,
                    tabs: const [
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
