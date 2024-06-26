import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/creator/presentation/providers/creator_providers.dart';
import 'package:d_reader_flutter/features/discover/genre/presentation/providers/genre_providers.dart';
import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/providers/filter_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/presentations/providers/common/tab_bar_provider.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/menus/sort_menu.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/filter/filter_container.dart';
import 'package:d_reader_flutter/features/discover/genre/presentation/widgets/expandable_list.dart';
import 'package:d_reader_flutter/features/settings/presentation/widgets/bottom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Text(
              'Filter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            // dont show on creators tab
            ref.watch(tabBarProvider) != 2
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(title: 'Show editions'),
                      const SizedBox(
                        height: 16,
                      ),
                      // for comics we have popular filter only
                      ref.watch(tabBarProvider) == 0
                          ? FilterContainer(
                              id: FilterId.popular,
                              text: FilterId.popular.displayText(),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: FilterContainer(
                                    id: FilterId.free,
                                    text: FilterId.free.displayText(),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: FilterContainer(
                                    id: FilterId.popular,
                                    text: FilterId.popular.displayText(),
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
            const Column(
              children: [
                SectionDivider(),
                SortMenu(),
              ],
            )
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
          context.pop();
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
    return const Column(
      children: [
        SizedBox(
          height: 24,
        ),
        Divider(
          height: 1,
          thickness: 2,
          color: ColorPalette.greyscale400,
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
