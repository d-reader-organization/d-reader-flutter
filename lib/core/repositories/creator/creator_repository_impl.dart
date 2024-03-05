import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/core/repositories/creator/creator_repository.dart';
import 'package:dio/dio.dart';

class CreatorRepositoryImpl implements CreatorRepository {
  final Dio client;

  CreatorRepositoryImpl({
    required this.client,
  });

  @override
  Future<List<CreatorModel>> getCreators({String? queryString}) async {
    final response = await client
        .get('/creator/get?$queryString')
        .then((value) => value.data);

    return response == null
        ? []
        : List<CreatorModel>.from(
            response.map(
              (item) => CreatorModel.fromJson(
                item,
              ),
            ),
          );
  }

  @override
  Future<CreatorModel?> getCreator(String slug) async {
    final response =
        await client.get('/creator/get/$slug').then((value) => value.data);

    return response != null ? CreatorModel.fromJson(response) : null;
  }

  @override
  Future<bool> followCreator(String slug) async {
    await client.patch('/creator/follow/$slug');
    return true;
  }
}
