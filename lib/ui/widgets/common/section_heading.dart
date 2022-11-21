import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/core/providers/tab_bar_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/views/discover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SectionHeading extends ConsumerWidget {
  final String title;
  final DiscoverTabViewEnum initialTab;
  const SectionHeading({
    Key? key,
    required this.title,
    required this.initialTab,
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
        GestureDetector(
          onTap: () {
            ref.read(tabBarProvider.notifier).setInitialIndex(initialTab.index);
            ref.read(scaffoldProvider.notifier).setNavigationIndex(1);
            ref.read(scaffoldPageController).animateToPage(
                  1,
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 350),
                );
          },
          child: Text(
            AppLocalizations.of(context)?.seeAll ?? 'See All',
            style: textTheme.titleSmall?.copyWith(
              color: ColorPalette.dReaderYellow100,
            ),
          ),
        ),
      ],
    );
  }
}
