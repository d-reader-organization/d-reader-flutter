import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';

abstract class WalletRepository {
  Future<List<WalletAsset>> myAssets();
  Future<WalletModel?> myWallet();
  Future<WalletModel?> updateAvatar(UpdateWalletPayload payload);
  Future<WalletModel?> updateWallet(UpdateWalletPayload payload);
}
