import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/core/providers/creator_provider.dart';
import 'package:d_reader_flutter/core/providers/discover/filter_provider.dart';
import 'package:d_reader_flutter/core/providers/genre_provider.dart';
import 'package:d_reader_flutter/core/providers/tab_bar_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/sort_menu.dart';
import 'package:d_reader_flutter/ui/widgets/discover/filter/filter_container.dart';
import 'package:d_reader_flutter/ui/widgets/genre/expandable_list.dart';
import 'package:d_reader_flutter/ui/widgets/settings/bottom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size(0, 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: AppBar(
            backgroundColor: ColorPalette.appBackgroundColor,
            elevation: 0,
            leading: SvgPicture.asset(
              'assets/icons/filter.svg',
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              height: 24,
              width: 24,
            ),
            leadingWidth: 24,
            title: const Text('Filter'),
            actions: [
              GestureDetector(
                  onTap: () {
                    return Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            ref.watch(tabBarProvider).selectedTabIndex == 1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(title: 'Show issues'),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: const [
                          Expanded(
                            child: FilterContainer(
                              id: FilterId.free,
                              text: 'Free to read',
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: FilterContainer(
                              id: FilterId.popular,
                              text: 'Popular',
                            ),
                          ),
                        ],
                      ),
                      const SectionDivider(),
                    ],
                  )
                : const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionTitle(title: 'Genres'),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(showAllGenresProvider.notifier)
                        .update((state) => !state);
                  },
                  child: Text(
                    ref.watch(showAllGenresProvider) ? 'Hide' : 'See all',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ColorPalette.dReaderYellow100,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const ExpandableGenreList(),
            ref.watch(tabBarProvider).selectedTabIndex == 1
                ? Column(
                    children: const [
                      SectionDivider(),
                      SortMenu(),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: SettingsButtonsBottom(
        isLoading: false,
        cancelText: 'Reset',
        confirmText: 'Filter',
        onCancel: () {
          ref.invalidate(selectedFilterProvider);
          ref.invalidate(selectedGenresProvider);
          ref.invalidate(selectedSortByProvider);
        },
        onSave: () {
          ref.invalidate(paginatedComicsProvider);
          ref.invalidate(paginatedIssuesProvider);
          ref.invalidate(paginatedCreatorsProvider);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(
          height: 24,
        ),
        Divider(
          height: 1,
          thickness: 2,
          color: ColorPalette.boxBackground300,
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}