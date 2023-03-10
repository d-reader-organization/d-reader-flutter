import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
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

  @override
  Future<WalletModel?> myWallet() async {
    String? responseBody = await IoCContainer.resolveContainer<ApiService>()
        .apiCallGet('/wallet/get/me');
    return responseBody == null
        ? null
        : WalletModel.fromJson(jsonDecode(responseBody));
  }

  @override
  Future<WalletModel?> updateAvatar(UpdateAvatarPayload payload) async {
    String? responseBody =
        await IoCContainer.resolveContainer<ApiService>().apiMultipartRequest(
      '/wallet/update/${payload.address}/avatar',
      payload,
    );
    return responseBody != null
        ? WalletModel.fromJson(jsonDecode(responseBody))
        : null;
  }

  @override
  Future<WalletModel?> updateWallet(
    String address,
  ) async {
    String? responseBody = await IoCContainer.resolveContainer<ApiService>()
        .apiCallPatch('/wallet/update/$address', {});
    return responseBody != null
        ? WalletModel.fromJson(jsonDecode(responseBody))
        : null;
  }
}
