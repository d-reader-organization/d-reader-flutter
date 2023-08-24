import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/models/wallet_asset.dart';

abstract class WalletRepository {
  Future<List<WalletAsset>> getAssets(String address);
  Future<dynamic> syncWallet(String address);
  Future<WalletModel?> getWallet(String address);
}
