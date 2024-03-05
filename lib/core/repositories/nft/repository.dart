import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';

abstract class NftRepository {
  Future<NftModel?> getNft(String address);
  Future<List<NftModel>> getNfts(String query);
}
