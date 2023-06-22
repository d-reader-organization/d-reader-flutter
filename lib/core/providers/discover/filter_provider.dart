import 'package:hooks_riverpod/hooks_riverpod.dart';

enum FilterId {
  free,
  popular,
}

enum SortByEnum { latest, rating, likes, readers, viewers }

enum SortDirection { asc, desc }

final selectedFilterProvider = StateProvider<FilterId?>((ref) {
  return null;
});

final selectedSortByProvider = StateProvider<SortByEnum?>((ref) {
  return null;
});

final showAllGenresProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final sortDirectionProvider = StateProvider.autoDispose<SortDirection>(
  (ref) {
    return SortDirection.desc;
  },
);
