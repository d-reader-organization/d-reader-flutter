import 'package:d_reader_flutter/ui/widgets/common/buttons/radio_button.dart';
import 'package:d_reader_flutter/ui/widgets/discover/filter/filter_container.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedFilterProvider = StateProvider<FilterId?>((ref) {
  return null;
});

final selectedSortByProvider = StateProvider<SortByEnum?>((ref) {
  return null;
});

final showAllGenresProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
