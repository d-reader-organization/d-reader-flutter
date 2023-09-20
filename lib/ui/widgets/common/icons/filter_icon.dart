import 'package:d_reader_flutter/core/providers/discover/filter_provider.dart';
import 'package:d_reader_flutter/core/providers/genre_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/filter_bottom_sheet.dart';
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
        decoration: BoxDecoration(
          color: ColorPalette.boxBackground200,
          borderRadius: BorderRadius.circular(
            8,
          ),
          border: isActive
              ? Border.all(
                  color: ColorPalette.dReaderYellow100,
                )
              : null,
        ),
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
