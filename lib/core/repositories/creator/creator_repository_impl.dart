import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/repositories/creator/creator_repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';

class CreatorRepositoryImpl implements CreatorRepository {
  @override
  Future<List<CreatorModel>> getCreators([String? queryString]) async {
    final String? responseBody =
        await ApiService.instance.apiCallGet('/creator/get?$queryString');
    if (responseBody == null) {
      return [];
    }
    Iterable decodedData = jsonDecode(responseBody);
    return List<CreatorModel>.from(
      decodedData.map(
        (item) => CreatorModel.fromJson(
          item,
        ),
      ),
    );
  }

  @override
  Future<CreatorModel> getCreator(String slug) async {
    final String? responseBody =
        await ApiService.instance.apiCallGet('/creator/get/$slug');
    dynamic decodedData = jsonDecode(responseBody!);
    return CreatorModel.fromJson(decodedData);
  }

  @override
  Future<bool> followCreator(String slug) async {
    await ApiService.instance.apiCallPost('/creator/follow/$slug');
    return true;
  }
}
