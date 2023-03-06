import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/repositories/wallet/repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';
import 'package:d_reader_flutter/ioc.dart';

class WalletRepositoryImpl implements WalletRepository {
  @override
  Future<List<WalletAsset>> myAssets() async {
    String? responseBody = await IoCContainer.resolveContainer<ApiService>()
        .apiCallGet('/wallet/get/my-assets');
    if (responseBody == null) {
      return [];
    }
    final decodedData = jsonDecode(responseBody);

    return List<WalletAsset>.from(
      decodedData.map(
        (item) => WalletAsset.fromJson(item),
      ),
    );
  }
}
