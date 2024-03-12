import 'package:d_reader_flutter/features/discover/genre/presentations/providers/genre_providers.dart';
import 'package:d_reader_flutter/features/discover/root/presentations/providers/filter_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/presentations/providers/common/search_provider.dart';
import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

String getSortByQueryString(SortByEnum selected, ScrollListType type) {
  if (type == ScrollListType.comicList) {
    if (selected == SortByEnum.likes) {
      return 'sortTag=likes';
    } else if (selected == SortByEnum.rating) {
      return 'sortTag=rating';
    } else if (selected == SortByEnum.readers) {
      return 'sortTag=readers';
    } else if (selected == SortByEnum.viewers) {
      return 'sortTag=viewers';
    } else if (selected == SortByEnum.published) {
      return 'sortTag=published';
    }
  } else if (type == ScrollListType.issueList) {
    if (selected == SortByEnum.latest) {
      return 'sortTag=latest';
    } else if (selected == SortByEnum.likes) {
      return 'sortTag=likes';
    } else if (selected == SortByEnum.rating) {
      return 'sortTag=rating';
    } else if (selected == SortByEnum.readers) {
      return 'sortTag=readers';
    } else if (selected == SortByEnum.viewers) {
      return 'sortTag=viewers';
    }
  } else if (type == ScrollListType.creatorList) {
    if (selected == SortByEnum.followers) {
      return 'sortTag=followers';
    }
  }

  return '';
}

String getSortDirection(SortDirection direction) {
  return direction == SortDirection.asc ? 'asc' : 'desc';
}

String getFilterQueryString(WidgetRef ref, ScrollListType scrollListType) {
  String search = ref.watch(searchProvider).search;
  final String genreTags = ref
      .read(selectedGenresProvider)
      .map((genreSlug) => 'genreSlugs[]=$genreSlug')
      .join('&');
  final FilterId? selectedFilter = ref.read(selectedFilterProvider);
  final SortByEnum? selectedSortBy = ref.read(selectedSortByProvider);
  final SortDirection selectedSortDirection = ref.read(sortDirectionProvider);
  final String tagFilter = _filterPerType(
    scrollListType: scrollListType,
    selectedFilter: selectedFilter,
  );
  final String sortByFilter = selectedSortBy != null
      ? getSortByQueryString(
          selectedSortBy,
          scrollListType,
        )
      : '';
  final String sortDirection = getSortDirection(selectedSortDirection);
  final String common =
      'sortOrder=$sortDirection&${adjustQueryString(genreTags)}${adjustQueryString(sortByFilter)}${adjustQueryString(tagFilter)}';
  final String query = scrollListType == ScrollListType.creatorList
      ? '$common${'nameSubstring=$search'}'
      : '$common${'titleSubstring=$search'}';
  return query;
}

String _filterPerType({
  required ScrollListType scrollListType,
  FilterId? selectedFilter,
}) {
  if (selectedFilter == null) {
    return '';
  }
  if (scrollListType == ScrollListType.issueList) {
    return selectedFilter == FilterId.free
        ? 'filterTag=free'
        : 'filterTag=popular';
  }
  return selectedFilter == FilterId.popular ? 'filterTag=popular' : '';
}

String adjustQueryString(String query) => query.isNotEmpty ? '$query&' : '';
