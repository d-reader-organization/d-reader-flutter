import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';

abstract class ComicRepository {
  Future<List<ComicModel>> getComics({String? queryString});
  Future<ComicModel?> getComic(String slug);
  Future<void> updateComicFavourite(String slug);
  Future<dynamic> rateComic({
    required String slug,
    required int rating,
  });
  Future<void> bookmarkComic(String slug);
  Future<List<ComicModel>> getOwnedComics({
    required int userId,
    required String query,
  });
}
