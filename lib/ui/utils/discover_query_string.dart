import 'package:d_reader_flutter/core/providers/discover/filter_provider.dart';
import 'package:d_reader_flutter/core/providers/genre_provider.dart';
import 'package:d_reader_flutter/core/providers/search_provider.dart';
import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/radio_button.dart';
import 'package:d_reader_flutter/ui/widgets/discover/filter/filter_container.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

String getSortByQueryString(SortByEnum selected) {
  if (selected == SortByEnum.likes) {
    return 'tag=likes';
  } else if (selected == SortByEnum.rating) {
    return 'tag=rating';
  } else if (selected == SortByEnum.readers) {
    return 'tag=readers';
  } else if (selected == SortByEnum.viewers) {
    return 'tag=viewers';
  }
  return '';
}

String getFilterQueryString(WidgetRef ref, ScrollListType scrollListType) {
  String search = ref.watch(searchProvider).search;
  final String genreTags = ref
      .read(selectedGenresProvider)
      .map((genreSlug) => 'genreSlugs[]=$genreSlug')
      .join('&');
  final FilterId? selectedFilter = ref.read(selectedFilterProvider);
  final SortByEnum? selectedSortBy = ref.read(selectedSortByProvider);
  final String tagFilter = selectedFilter != null
      ? selectedFilter == FilterId.free
          ? 'tag=free'
          : 'tag=popular'
      : '';
  final String sortByFilter =
      selectedSortBy != null ? getSortByQueryString(selectedSortBy) : '';
  final String common =
      '${adjustQueryString(genreTags)}${adjustQueryString(sortByFilter)}${adjustQueryString(tagFilter)}';
  final String query = scrollListType == ScrollListType.issueList
      ? '$common${'titleSubstring=$search'}'
      : '$common${'nameSubstring=$search'}';
  return query;
}

String adjustQueryString(String query) => query.isNotEmpty ? '$query&' : '';
