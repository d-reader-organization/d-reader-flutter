import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/repositories/comic/comic_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final comicProvider = FutureProvider<List<ComicModel>>((ref) async {
  ComicRepositoryImpl comicRepository = ComicRepositoryImpl();
  return await comicRepository.getComics();
});
