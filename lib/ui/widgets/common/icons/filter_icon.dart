import 'package:d_reader_flutter/features/discover/genre/presentations/providers/genre_providers.dart';
import 'package:d_reader_flutter/features/discover/root/presentations/providers/filter_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/bottom_sheets/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterIcon extends ConsumerWidget {
  const FilterIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isActive = ref.watch(selectedFilterProvider) != null ||
        ref.watch(selectedGenresProvider).isNotEmpty ||
        ref.watch(selectedSortByProvider) != null;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) {
            return const FilterBottomSheet();
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: SvgPicture.asset(
          'assets/icons/filter.svg',
          colorFilter: isActive
              ? const ColorFilter.mode(
                  ColorPalette.dReaderYellow100,
                  BlendMode.srcIn,
                )
              : null,
        ),
      ),
    );
  }
}
