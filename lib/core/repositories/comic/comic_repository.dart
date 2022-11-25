import 'package:d_reader_flutter/core/models/comic.dart';

abstract class ComicRepository {
  Future<List<ComicModel>> getComics();
  Future<ComicModel?> getComic(String slug);
  Future<void> updateComicFavourite(String slug);
}
