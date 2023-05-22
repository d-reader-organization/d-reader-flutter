import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/api_error.dart';
import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/repositories/comic/comic_repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';

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
    String? responseBody =
        await ApiService.instance.apiCallGet('/comic/get/$slug');
    return responseBody == null
        ? null
        : ComicModel.fromJson(jsonDecode(responseBody));
  }

  @override
  Future<void> updateComicFavourite(String slug) async {
    await ApiService.instance.apiCallPatch('/comic/favouritise/$slug');
  }

  @override
  Future rateComic({required String slug, required int rating}) async {
    final result = await ApiService.instance.apiCallPatch(
      '/comic/rate/$slug',
      body: {
        'rating': rating,
      },
    );
    if (result is ApiError) {
      return result.message;
    }
    return result != null ? ComicModel.fromJson(jsonDecode(result)) : result;
  }
}
