import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/repositories/comic/comic_repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:d_reader_flutter/ui/utils/append_default_query_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final comicsProvider =
    FutureProvider.family<List<ComicModel>, String?>((ref, queryString) async {
  return await IoCContainer.resolveContainer<ComicRepositoryImpl>()
      .getComics(queryString: appendDefaultQuery(queryString));
});

final comicSlugProvider =
    FutureProvider.family<ComicModel?, String>((ref, slug) async {
  return await IoCContainer.resolveContainer<ComicRepositoryImpl>()
      .getComic(slug);
});

final updateComicFavouriteProvider =
    FutureProvider.family<void, String>((ref, slug) {
  IoCContainer.resolveContainer<ComicRepositoryImpl>()
      .updateComicFavourite(slug);
});
