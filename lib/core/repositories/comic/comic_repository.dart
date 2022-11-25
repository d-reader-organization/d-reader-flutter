import 'package:d_reader_flutter/core/models/comic.dart';

abstract class ComicRepository {
  Future<List<ComicModel>> getComics();
  Future<void> updateComicFavourite(String slug);
}
