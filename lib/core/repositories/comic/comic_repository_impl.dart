import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/repositories/comic/comic_repository.dart';
import 'package:dio/dio.dart';

class ComicRepositoryImpl implements ComicRepository {
  final Dio client;
  ComicRepositoryImpl({
    required this.client,
  });

  @override
  Future<List<ComicModel>> getComics({String? queryString}) async {
    final response = await client
        .get<List<dynamic>>('/comic/get?$queryString')
        .then((value) => value.data);

    return response != null
        ? List<ComicModel>.from(
            response.map(
              (item) => ComicModel.fromJson(
                item,
              ),
            ),
          )
        : [];
  }

  @override
  Future<ComicModel?> getComic(String slug) async {
    final response = await client
        .get<dynamic>('/comic/get/$slug')
        .then((value) => value.data);

    return response != null ? ComicModel.fromJson(response) : null;
  }

  @override
  Future<void> updateComicFavourite(String slug) async {
    await client.patch('/comic/favouritise/$slug');
  }

  @override
  Future rateComic({required String slug, required int rating}) async {
    final result = await client
        .patch(
          '/comic/rate/$slug',
          data: {
            'rating': rating,
          },
        )
        .then((value) => value.data)
        .onError((error, stackTrace) {
          return error.toString();
        });

    return result != null ? ComicModel.fromJson(result) : result;
  }

  @override
  Future<List<ComicModel>> getOwnedComics(
      {required int userId, required String query}) async {
    final response = await client
        .get('/comic/get/by-owner/$userId?$query')
        .then((value) => value.data);

    return response != null
        ? List<ComicModel>.from(
            response.map(
              (item) => ComicModel.fromJson(
                item,
              ),
            ),
          )
        : [];
  }
}
