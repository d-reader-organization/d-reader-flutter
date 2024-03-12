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
  Future<Either<AppException, NftModel?>> getNft(String address) async {
    try {
      final response = await networkService.get('/nft/get/$address');
      return response.fold((exception) => Left(exception), (result) {
        return Right(
          NftModel.fromJson(
            result.data,
          ),
        );
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier: '${exception.toString()}NftRemoteDataSource.getNft',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<NftModel>>> getNfts(String query) async {
    try {
      final response = await networkService.get('/nft/get?$query');

      return response.fold((exception) => Left(exception), (result) {
        return Right(
          List<NftModel>.from(
            result.data.map(
              (item) => NftModel.fromJson(
                item,
              ),
            ),
          ),
        );
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier: '${exception.toString()}NftRemoteDataSource.getNfts',
        ),
      );
    }
  }
}
