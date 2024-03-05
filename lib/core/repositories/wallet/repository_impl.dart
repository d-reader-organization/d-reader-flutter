import 'package:d_reader_flutter/core/repositories/wallet/repository.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet_asset.dart';
import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class WalletRepositoryImpl implements WalletRepository {
  final Dio client;

  WalletRepositoryImpl({
    required this.client,
  });
  @override
  Future<List<WalletAsset>> getAssets(String address) async {
    final response = await client
        .get('/wallet/get/$address/assets')
        .then((value) => value.data);

    return response != null
        ? List<WalletAsset>.from(
            response.map(
              (item) => WalletAsset.fromJson(item),
            ),
          )
        : [];
  }

  @override
  Future syncWallet(String address) {
    return client.get('/wallet/sync/$address').then((value) => value.data);
  }

  @override
  Future<WalletModel?> getWallet(String address) async {
    try {
      if (address.isEmpty) {
        return null;
      }
      final response =
          await client.get('/wallet/get/$address').then((value) => value.data);
      return response != null ? WalletModel.fromJson(response) : null;
    } catch (exception, stackTrace) {
      Sentry.captureException(exception,
          stackTrace: 'failed to get wallet ${stackTrace.toString()}');
      throw Exception(exception);
    }
  }

  @override
  Future updateWallet({required String address, required String label}) async {
    try {
      final result = await client.patch('/wallet/update/$address', data: {
        'label': label,
      }).then((value) => value.data);
      return result != null
          ? WalletModel.fromJson(result)
          : 'Failed to update wallet';
    } catch (exception) {
      if (exception is DioException) {
        final dynamic message = exception.response?.data?['message'];
        return message != null
            ? message is List
                ? message.join('. ')
                : message
            : exception.response?.data.toString();
      }
      throw Exception(exception);
    }
  }
}
