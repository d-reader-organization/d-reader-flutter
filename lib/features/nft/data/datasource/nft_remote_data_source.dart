import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class NftDataSource {
  Future<Either<AppException, NftModel?>> getNft(String address);
  Future<Either<AppException, List<NftModel>>> getNfts(String query);
}

class NftRemoteDataSource implements NftDataSource {
  final NetworkService networkService;

  NftRemoteDataSource(this.networkService);

  @override
  Future<Either<AppException, NftModel?>> getNft(String address) {
    // TODO: implement getNft
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<NftModel>>> getNfts(String query) {
    // TODO: implement getNfts
    throw UnimplementedError();
  }
}
