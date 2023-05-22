import 'package:d_reader_flutter/core/models/comic.dart';

abstract class ComicRepository {
  Future<List<ComicModel>> getComics({String? queryString});
  Future<ComicModel?> getComic(String slug);
  Future<void> updateComicFavourite(String slug);
  Future<dynamic> rateComic({
    required String slug,
    required int rating,
  });
}
