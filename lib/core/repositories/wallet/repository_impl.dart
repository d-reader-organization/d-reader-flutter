import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/models/wallet_asset.dart';
import 'package:d_reader_flutter/core/repositories/wallet/repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';

class WalletRepositoryImpl implements WalletRepository {
  @override
  Future<List<WalletAsset>> myAssets() async {
    String? responseBody =
        await ApiService.instance.apiCallGet('/wallet/get/my-assets');
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
    String? responseBody =
        await ApiService.instance.apiCallGet('/wallet/get/me');
    return responseBody == null
        ? null
        : WalletModel.fromJson(jsonDecode(responseBody));
  }

  @override
  Future<WalletModel?> updateAvatar(UpdateWalletPayload payload) async {
    String? responseBody = await ApiService.instance.apiMultipartRequest(
      '/wallet/update/${payload.address}/avatar',
      payload,
    );
    return responseBody != null
        ? WalletModel.fromJson(jsonDecode(responseBody))
        : null;
  }

  @override
  Future<WalletModel?> updateWallet(
    UpdateWalletPayload payload,
  ) async {
    String? responseBody = await ApiService.instance.apiCallPatch(
      '/wallet/update/${payload.address}',
      body: {
        "name": payload.name,
      },
    );
    return responseBody != null
        ? WalletModel.fromJson(jsonDecode(responseBody))
        : null;
  }

  @override
  Future<bool> validateName(String name) async {
    if (name.isEmpty) {
      return false;
    }
    try {
      String? responseBody = await ApiService.instance
          .apiCallGet('/auth/wallet/validate-name/$name');
      return responseBody != null ? jsonDecode(responseBody) : false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<WalletModel?> updateReferrer(String referrer) async {
    String? responseBody = await ApiService.instance.apiCallPatch(
      '/wallet/redeem-referral/$referrer',
    );
    return responseBody != null
        ? WalletModel.fromJson(jsonDecode(responseBody))
        : null;
  }
}
