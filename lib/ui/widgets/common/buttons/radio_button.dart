import 'package:d_reader_flutter/features/discover/root/presentations/providers/filter_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterRadioButton extends ConsumerWidget {
  final String title;
  final SortByEnum value;
  const FilterRadioButton({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RadioListTile(
      value: value,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      selectedTileColor: ColorPalette.greyscale500,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          8,
        ),
      ),
      selected: ref.watch(selectedSortByProvider) == value,
      controlAffinity: ListTileControlAffinity.trailing,
      toggleable: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      groupValue: ref.watch(selectedSortByProvider),
      activeColor: Colors.white,
      onChanged: (SortByEnum? value) {
        ref.read(selectedSortByProvider.notifier).update((state) => value);
      },
    );
  }
}
