import 'package:d_reader_flutter/core/models/nft.dart';

abstract class NftRepository {
  Future<NftModel?> getNft(String address);
}
