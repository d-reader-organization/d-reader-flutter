import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/models/wallet_asset.dart';
import 'package:d_reader_flutter/core/repositories/wallet/repository.dart';
import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class WalletRepositoryImpl implements WalletRepository {
  final Dio client;

  WalletRepositoryImpl({
    required this.client,
  });
  @override
  Future<List<WalletAsset>> getAssets(String address) async {
    final response =
        await client.get('/wallet/get/$address/assets').then((value) => value.data);

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
}
