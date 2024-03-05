import 'package:d_reader_flutter/core/repositories/nft/repository.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';

import 'package:dio/dio.dart';

class NftRepositoryImpl implements NftRepository {
  final Dio client;

  NftRepositoryImpl({
    required this.client,
  });
  @override
  Future<NftModel?> getNft(String address) async {
    final response =
        await client.get('/nft/get/$address').then((value) => value.data);

    return response != null ? NftModel.fromJson(response) : null;
  }

  @override
  Future<List<NftModel>> getNfts(String query) async {
    final response =
        await client.get('/nft/get?$query').then((value) => value.data);

    return response != null
        ? List<NftModel>.from(
            response.map(
              (item) => NftModel.fromJson(
                item,
              ),
            ),
          )
        : [];
  }
}
