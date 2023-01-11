import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/repositories/creator/creator_repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';
import 'package:d_reader_flutter/ioc.dart';

class CreatorRepositoryImpl implements CreatorRepository {
  @override
  Future<List<CreatorModel>> getCreators() async {
    final String? responseBody =
        await IoCContainer.resolveContainer<ApiService>()
            .apiCallGet('/creator/get');
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
        await IoCContainer.resolveContainer<ApiService>()
            .apiCallGet('/creator/get/$slug');
    dynamic decodedData = jsonDecode(responseBody!);
    return CreatorModel.fromJson(decodedData);
  }
}
