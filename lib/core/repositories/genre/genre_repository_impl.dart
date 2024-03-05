import 'package:d_reader_flutter/core/repositories/genre/genre_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/genre.dart';
import 'package:dio/dio.dart';

class GenreRepositoryImpl implements GenreRepository {
  final Dio client;

  GenreRepositoryImpl({
    required this.client,
  });

  @override
  Future<List<GenreModel>> getGenres() async {
    final response = await client.get('/genre/get').then((value) => value.data);

    return response != null
        ? List<GenreModel>.from(
            response.map(
              (item) => GenreModel.fromJson(
                item,
              ),
            ),
          )
        : [];
  }
}
