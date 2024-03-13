import 'package:d_reader_flutter/features/discover/genre/presentations/providers/genre_providers.dart';
import 'package:d_reader_flutter/features/discover/root/presentations/providers/filter_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/presentations/providers/common/tab_bar_provider.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/scaffold_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/views/discover.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SectionHeading extends ConsumerWidget {
  final String title;
  final DiscoverTabViewEnum? initialTab;
  final FilterId? filter;
  final SortByEnum? sort;

  const SectionHeading({
    super.key,
    required this.title,
    this.initialTab,
    this.filter,
    this.sort,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textTheme.headlineMedium,
          ),
          initialTab != null
              ? GestureDetector(
                  onTap: initialTab != null
                      ? () {
                          ref
                              .read(tabBarProvider.notifier)
                              .update((state) => initialTab!.index);

                          ref
                              .read(scaffoldNavigationIndexProvider.notifier)
                              .update((state) => 1);
                          ref.read(scaffoldPageController).animateToPage(
                                1,
                                curve: Curves.linear,
                                duration: const Duration(milliseconds: 350),
                              );
                          ref.invalidate(selectedGenresProvider);
                          if (filter != null) {
                            ref.invalidate(selectedSortByProvider);
                            ref
                                .read(selectedFilterProvider.notifier)
                                .update((state) => filter);
                          } else if (sort != null) {
                            ref.invalidate(selectedFilterProvider);
                            ref
                                .read(selectedSortByProvider.notifier)
                                .update((state) => sort);
                          }
                        }
                      : null,
                  child: Text(
                    'See All',
                    style: textTheme.titleMedium?.copyWith(
                      color: ColorPalette.dReaderYellow100,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
