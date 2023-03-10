import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';

abstract class WalletRepository {
  Future<List<WalletAsset>> myAssets();
  Future<WalletModel?> myWallet();
  Future<WalletModel?> updateAvatar(UpdateAvatarPayload payload);
  Future<WalletModel?> updateWallet(String address);
}
