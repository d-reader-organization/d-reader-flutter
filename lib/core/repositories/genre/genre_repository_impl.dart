import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/core/repositories/genre/genre_repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';
import 'package:d_reader_flutter/ioc.dart';

class GenreRepositoryImpl implements GenreRepository {
  @override
  Future<List<GenreModel>> getGenres() async {
    String? responseBody = await IoCContainer.resolveContainer<ApiService>()
        .apiCallGet('/genre/get');
    if (responseBody == null) {
      return [];
    }
    Iterable decodedData = jsonDecode(responseBody);
    return List<GenreModel>.from(
      decodedData.map(
        (item) => GenreModel.fromJson(
          item,
        ),
      ),
    );
  }
}
