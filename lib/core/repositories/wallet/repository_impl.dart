import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/api_error.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/models/wallet_asset.dart';
import 'package:d_reader_flutter/core/repositories/wallet/repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
  Future<dynamic> updateWallet(
    UpdateWalletPayload payload,
  ) async {
    dynamic responseBody = await ApiService.instance.apiCallPatch(
      '/wallet/update/${payload.address}',
      body: {
        if (payload.name != null && payload.name!.isNotEmpty)
          "name": payload.name,
        if (payload.referrer != null && payload.referrer!.isNotEmpty)
          "referrer": payload.referrer
      },
    );
    if (responseBody is ApiError) {
      Sentry.captureMessage(
        'Error: ${responseBody.message}: Status: ${responseBody.statusCode} - ${responseBody.error}',
        level: SentryLevel.error,
      );
      return responseBody.message;
    }
    return responseBody != null
        ? WalletModel.fromJson(jsonDecode(responseBody))
        : null;
  }

  @override
  Future<bool> validateName(String name) async {
    if (name.trim().isEmpty) {
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
  Future<String> updateReferrer(String referrer) async {
    dynamic responseBody = await ApiService.instance.apiCallPatch(
      '/wallet/redeem-referral/$referrer',
    );
    if (responseBody is ApiError) {
      return responseBody.message;
    }
    return 'OK';
  }
}
