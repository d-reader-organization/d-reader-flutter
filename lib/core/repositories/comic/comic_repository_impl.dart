import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/repositories/comic/comic_repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';

class ComicRepositoryImpl implements ComicRepository {
  @override
  Future<List<ComicModel>> getComics() async {
    String? responseBody = await ApiService.apiCallGet('/comic/get');
    if (responseBody == null) {
      return [];
    }
    Iterable decodedData = jsonDecode(responseBody);
    return List<ComicModel>.from(
      decodedData.map(
        (item) => ComicModel.fromJson(
          item,
        ),
      ),
    );
  }

  @override
  Future<ComicModel?> getComic(String slug) async {
    String? responseBody = await ApiService.apiCallGet('/comic/get/$slug');
    return responseBody == null
        ? null
        : ComicModel.fromJson(jsonDecode(responseBody));
  }

  @override
  Future<void> updateComicFavourite(String slug) async {
    ApiService.apiCallPatch('/comic/favouritise/$slug');
  }
}
