import 'package:d_reader_flutter/features/nft/data/datasource/nft_remote_data_source.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/features/nft/domain/repositories/nft_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class NftRepositoryImpl implements NftRepository {
  final NftDataSource dataSource;

  NftRepositoryImpl(this.dataSource);
  @override
  Future<Either<AppException, NftModel?>> getNft(String address) {
    return dataSource.getNft(address);
  }

  @override
  Future<Either<AppException, List<NftModel>>> getNfts(String query) {
    return dataSource.getNfts(query);
  }
}
