import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/repositories/comic/comic_repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';
import 'package:d_reader_flutter/ioc.dart';

class ComicRepositoryImpl implements ComicRepository {
  @override
  Future<List<ComicModel>> getComics({String? queryString}) async {
    String? responseBody =
        await ApiService.instance.apiCallGet('/comic/get?$queryString');
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
    String? responseBody = await IoCContainer.resolveContainer<ApiService>()
        .apiCallGet('/comic/get/$slug');
    return responseBody == null
        ? null
        : ComicModel.fromJson(jsonDecode(responseBody));
  }

  @override
  Future<void> updateComicFavourite(String slug) async {
    await IoCContainer.resolveContainer<ApiService>()
        .apiCallPatch('/comic/favouritise/$slug');
  }
}
