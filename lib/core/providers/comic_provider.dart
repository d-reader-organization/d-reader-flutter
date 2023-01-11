import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/repositories/comic/comic_repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final comicsProvider = FutureProvider<List<ComicModel>>((ref) async {
  return await IoCContainer.resolveContainer<ComicRepositoryImpl>().getComics();
});

final comicSlugProvider =
    FutureProvider.family<ComicModel?, String>((ref, slug) async {
  return await IoCContainer.resolveContainer<ComicRepositoryImpl>()
      .getComic(slug);
});

final comicQueryStringProvider =
    FutureProvider.family<List<ComicModel>, String>((ref, queryString) async {
  return await IoCContainer.resolveContainer<ComicRepositoryImpl>()
      .getComics(queryString: queryString);
});

final updateComicFavouriteProvider =
    FutureProvider.family<void, String>((ref, slug) {
  IoCContainer.resolveContainer<ComicRepositoryImpl>()
      .updateComicFavourite(slug);
});
