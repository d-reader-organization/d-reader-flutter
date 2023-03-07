import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/repositories/nft/repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';
import 'package:d_reader_flutter/ioc.dart';

class NftRepositoryImpl implements NftRepository {
  @override
  Future<NftModel?> getNft(String address) async {
    String? responseBody = await IoCContainer.resolveContainer<ApiService>()
        .apiCallGet('/nft/get/$address');
    return responseBody != null
        ? NftModel.fromJson(jsonDecode(responseBody))
        : null;
  }
}
