import 'package:d_reader_flutter/core/providers/discover/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum SortByEnum { latest, rating, likes, readers, viewers }

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
