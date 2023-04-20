import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/notifiers/pagination_notifier.dart';
import 'package:d_reader_flutter/core/repositories/comic/comic_repository_impl.dart';
import 'package:d_reader_flutter/core/states/pagination_state.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:d_reader_flutter/ui/utils/append_default_query_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final comicsProvider =
    FutureProvider.autoDispose.family<List<ComicModel>, String?>(
  (ref, queryString) async {
    return IoCContainer.resolveContainer<ComicRepositoryImpl>().getComics(
        queryString: queryString != null && queryString.isNotEmpty
            ? queryString
            : appendDefaultQuery(queryString));
  },
);

final paginatedComicsProvider = StateNotifierProvider.autoDispose.family<
    PaginationNotifier<ComicModel>,
    PaginationState<ComicModel>,
    String?>((ref, query) {
  final fetch = IoCContainer.resolveContainer<ComicRepositoryImpl>().getComics;
  return PaginationNotifier<ComicModel>(
    fetch: fetch,
    query: query,
  )..init();
});

final comicSlugProvider =
    FutureProvider.autoDispose.family<ComicModel?, String>((ref, slug) async {
  return IoCContainer.resolveContainer<ComicRepositoryImpl>().getComic(slug);
});

final updateComicFavouriteProvider =
    FutureProvider.autoDispose.family<void, String>((ref, slug) {
  IoCContainer.resolveContainer<ComicRepositoryImpl>()
      .updateComicFavourite(slug);
});
