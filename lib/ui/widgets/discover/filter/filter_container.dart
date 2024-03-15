import 'package:d_reader_flutter/features/discover/root/presentation/providers/filter_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterContainer extends ConsumerWidget {
  final String text;
  final FilterId id;
  const FilterContainer({
    super.key,
    required this.id,
    required this.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final FilterId? selectedFilter = ref.read(selectedFilterProvider);
        ref
            .read(selectedFilterProvider.notifier)
            .update((state) => selectedFilter != id ? id : null);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: ref.watch(selectedFilterProvider) == id
              ? ColorPalette.greyscale500
              : ColorPalette.appBackgroundColor,
          borderRadius: BorderRadius.circular(
            8,
          ),
          border: Border.all(
            color: ref.watch(selectedFilterProvider) == id
                ? ColorPalette.dReaderYellow100
                : ColorPalette.greyscale400,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
