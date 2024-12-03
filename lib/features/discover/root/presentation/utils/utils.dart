import 'package:d_reader_flutter/features/discover/genre/presentation/providers/genre_providers.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/providers/filter_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/presentations/providers/common/search_provider.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const String _genreSlugsKey = 'genreSlugs[]';
const String _sortOrderKey = 'sortOrder';
const String _sortTagKey = 'sortTag';
const String _filterTagKey = 'filterTag';
const String _searchKey = 'search';

String _prependQueryWithKey({required String key, required String value}) =>
    value.isNotEmpty ? '$key=$value' : '';

bool _isCreatorTagOnly(SortByEnum selected) =>
    selected == SortByEnum.followers || selected == SortByEnum.name;

String _getSortTagValue(SortByEnum selected, ScrollListType type) {
  final bool isCreatorListType = type == ScrollListType.creatorList;

  if (_isCreatorTagOnly(selected)) {
    return isCreatorListType ? selected.value() : '';
  }

  if (isCreatorListType) {
    return '';
  }

  // special handling for comic filters when latest/published is selected
  if (type == ScrollListType.comicList && selected == SortByEnum.latest) {
    return SortByEnum.published.value();
  }
  return selected.value();
}

String getFilterQueryString(WidgetRef ref, ScrollListType scrollListType) {
  String search = ref.watch(searchProvider).search;
  final String genreTags = ref
      .read(selectedGenresProvider)
      .map((genreSlug) => '$_genreSlugsKey=$genreSlug')
      .join('&');
  final FilterId? selectedFilter = ref.read(selectedFilterProvider);
  final SortByEnum? selectedSortBy = ref.read(selectedSortByProvider);
  final SortDirection selectedSortDirection = ref.read(sortDirectionProvider);
  final String filterBy = _prependQueryWithKey(
    key: _filterTagKey,
    value: _filterPerType(
      scrollListType: scrollListType,
      selectedFilter: selectedFilter,
    ),
  );
  final String sortByFilter = selectedSortBy != null
      ? _prependQueryWithKey(
          key: _sortTagKey,
          value: _getSortTagValue(
            selectedSortBy,
            scrollListType,
          ),
        )
      : '';
  final String sortDirection = getSortDirection(selectedSortDirection);
  final String common =
      '$_sortOrderKey=$sortDirection&${_adjustQueryString(genreTags)}${_adjustQueryString(sortByFilter)}${_adjustQueryString(filterBy)}';
  final String query =
      '$common${search.isNotEmpty ? '$_searchKey=$search' : ''}';
  return query;
}

String _filterPerType({
  required ScrollListType scrollListType,
  FilterId? selectedFilter,
}) =>
    selectedFilter == null ? '' : selectedFilter.value();

String _adjustQueryString(String query) => query.isNotEmpty ? '$query&' : '';
