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
    // if (payload.avatar == null) {
    //   return null;
    // }
    // String fileName = payload.avatar!.path.split('/').last;

    // var formData = FormData.fromMap({
    //   'image': MultipartFile.fromBytes(payload.avatar!.readAsBytesSync(),
    //       filename: fileName,
    //       headers: {
    //         'Content-Type': [
    //           'multipart/form-data',
    //         ],
    //       }),
    // });

    // final response = await client
    //     .patch('/wallet/update/${payload.address}/avatar',
    //         data: formData,
    //         options: Options(headers: {
    //           'Content-Type': 'multipart/form-data',
    //         }))
    //     .then((value) => value.data)
    //     .onError((error, stackTrace) {
    //   print(error);
    // });

    // return response != null ? WalletModel.fromJson(response) : null;
  }

  @override
  Future<dynamic> updateWallet(
    UpdateWalletPayload payload,
  ) async {
    final response = await client.patch(
      '/wallet/update/${payload.address}',
      data: {
        if (payload.name != null && payload.name!.isNotEmpty)
          "name": payload.name,
        if (payload.referrer != null && payload.referrer!.isNotEmpty)
          "referrer": payload.referrer
      },
    ).then((value) {
      if (value.statusCode != 200) {
        return ApiError(
          error: value.data['error'],
          message: value.data['message'] is List
              ? value.data['message'].join('. ')
              : value.data['message'],
          statusCode: value.data['statusCode'] ?? 500,
        );
      }
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
      if (value.statusCode != 200) {
        return ApiError(
          error: value.data['error'],
          message: value.data['message'] is List
              ? value.data['message'].join('. ')
              : value.data['message'],
          statusCode: value.data['statusCode'] ?? 500,
        );
      }
      return value.data;
    });

    if (response is ApiError) {
      return response.message;
    }
    return 'OK';
  }

  @override
  Future syncWallet() {
    return ApiService.instance.apiCallGet('/wallet/sync');
  }
}
