import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/repositories/nft/repository.dart';

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
}
