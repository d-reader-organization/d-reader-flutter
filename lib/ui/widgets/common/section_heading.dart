import 'package:d_reader_flutter/core/providers/discover/filter_provider.dart';
import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/core/providers/tab_bar_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/views/discover.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/radio_button.dart';
import 'package:d_reader_flutter/ui/widgets/discover/filter/filter_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SectionHeading extends ConsumerWidget {
  final String title;
  final DiscoverTabViewEnum? initialTab;
  final FilterId? filter;
  final SortByEnum? sort;
  const SectionHeading({
    Key? key,
    required this.title,
    this.initialTab,
    this.filter,
    this.sort,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
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
                            .setTabIndex(initialTab!.index);
                        ref
                            .read(scaffoldProvider.notifier)
                            .setNavigationIndex(1);
                        ref.read(scaffoldPageController).animateToPage(
                              1,
                              curve: Curves.linear,
                              duration: const Duration(milliseconds: 350),
                            );
                        if (filter != null) {
                          ref
                              .read(selectedFilterProvider.notifier)
                              .update((state) => filter);
                        } else if (sort != null) {
                          ref
                              .read(selectedSortByProvider.notifier)
                              .update((state) => sort);
                        }
                      }
                    : null,
                child: Text(
                  AppLocalizations.of(context)?.seeAll ?? 'See All',
                  style: textTheme.titleSmall?.copyWith(
                    color: ColorPalette.dReaderYellow100,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
