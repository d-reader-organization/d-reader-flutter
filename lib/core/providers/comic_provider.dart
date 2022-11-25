import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/repositories/comic/comic_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final comicsProvider = FutureProvider<List<ComicModel>>((ref) async {
  ComicRepositoryImpl comicRepository = ComicRepositoryImpl();
  return await comicRepository.getComics();
});

final comicSlugProvider =
    FutureProvider.family<ComicModel?, String>((ref, slug) async {
  ComicRepositoryImpl comicRepositoryImpl = ComicRepositoryImpl();
  return await comicRepositoryImpl.getComic(slug);
});

final updateComicFavouriteProvider =
    FutureProvider.family<void, String>((ref, slug) {
  ComicRepositoryImpl comicRepository = ComicRepositoryImpl();
  comicRepository.updateComicFavourite(slug);
});
