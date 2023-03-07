import 'package:d_reader_flutter/core/models/nft.dart';

abstract class WalletRepository {
  Future<List<WalletAsset>> myAssets();
}
