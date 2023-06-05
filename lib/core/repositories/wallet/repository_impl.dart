import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/api_error.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/models/wallet_asset.dart';
import 'package:d_reader_flutter/core/repositories/wallet/repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class WalletRepositoryImpl implements WalletRepository {
  final Dio client;

  WalletRepositoryImpl({
    required this.client,
  });
  @override
  Future<List<WalletAsset>> myAssets() async {
    final response =
        await client.get('/wallet/get/my-assets').then((value) => value.data);

    return response != null
        ? List<WalletAsset>.from(
            response.map(
              (item) => WalletAsset.fromJson(item),
            ),
          )
        : [];
  }

  @override
  Future<WalletModel?> myWallet() async {
    final response =
        await client.get('/wallet/get/me').then((value) => value.data);
    return response != null ? WalletModel.fromJson(response) : null;
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
    try {
      final response = await client.patch(
        '/wallet/update/${payload.address}',
        data: {
          if (payload.name != null && payload.name!.isNotEmpty)
            "name": payload.name,
          if (payload.referrer != null && payload.referrer!.isNotEmpty)
            "referrer": payload.referrer
        },
      ).then((value) {
        return value.data;
      });

      if (response is ApiError) {
        Sentry.captureMessage(
          'Error: ${response.message}: Status: ${response.statusCode} - ${response.error}',
          level: SentryLevel.error,
        );
        return response.message;
      }
      return response != null ? WalletModel.fromJson(response) : null;
    } catch (err) {
      if (err is DioError) {
        Sentry.captureException(err);
        return err.response?.data['message'];
      }
      Sentry.captureException(err);
      return err.toString();
    }
  }

  @override
  Future<bool> validateName(String name) async {
    if (name.trim().isEmpty) {
      return false;
    }
    try {
      final response = await client
          .get('/auth/wallet/validate-name/$name')
          .then((value) => value.data);
      return response != null ? true : false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> updateReferrer(String referrer) async {
    final response = await client
        .patch(
      '/wallet/redeem-referral/$referrer',
    )
        .then((value) {
      return 'OK';
    }).onError((error, stackTrace) {
      if (error is DioError) {
        return error.response?.data['message'];
      }
      return error.toString();
    });

    return response;
  }

  @override
  Future syncWallet() {
    return client.get('/wallet/sync').then((value) => value.data);
  }
}
