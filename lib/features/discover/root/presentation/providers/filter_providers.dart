import 'package:d_reader_flutter/shared/domain/models/enums.dart';
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

final sortDirectionProvider = StateProvider<SortDirection>(
  (ref) {
    return SortDirection.desc;
  },
);

final comicSortDirectionProvider = StateProvider<SortDirection>(
  (ref) {
    return SortDirection.asc;
  },
);
