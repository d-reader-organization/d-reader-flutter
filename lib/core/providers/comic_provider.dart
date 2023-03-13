import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/repositories/comic/comic_repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:d_reader_flutter/ui/utils/append_default_query_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final comicsProvider =
    FutureProvider.autoDispose.family<List<ComicModel>, String?>(
  (ref, queryString) async {
    return IoCContainer.resolveContainer<ComicRepositoryImpl>()
        .getComics(queryString: appendDefaultQuery(queryString));
  },
);

final comicSlugProvider =
    FutureProvider.autoDispose.family<ComicModel?, String>((ref, slug) async {
  return IoCContainer.resolveContainer<ComicRepositoryImpl>().getComic(slug);
});

final updateComicFavouriteProvider =
    FutureProvider.autoDispose.family<void, String>((ref, slug) {
  IoCContainer.resolveContainer<ComicRepositoryImpl>()
      .updateComicFavourite(slug);
});
