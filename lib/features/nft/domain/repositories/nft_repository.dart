import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class NftRepository {
  Future<Either<AppException, NftModel?>> getNft(String address);
  Future<Either<AppException, List<NftModel>>> getNfts(String query);
}
