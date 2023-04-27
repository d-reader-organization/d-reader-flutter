import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/models/wallet_asset.dart';

abstract class WalletRepository {
  Future<List<WalletAsset>> myAssets();
  Future<WalletModel?> myWallet();
  Future<WalletModel?> updateAvatar(UpdateWalletPayload payload);
  Future<WalletModel?> updateWallet(UpdateWalletPayload payload);
  Future<bool> validateName(String name);
}
