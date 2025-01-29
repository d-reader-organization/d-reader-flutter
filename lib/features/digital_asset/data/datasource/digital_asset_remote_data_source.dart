import 'package:d_reader_flutter/features/digital_asset/domain/models/digital_asset.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

const String _controllerPath = 'asset';

abstract class DigitalAssetDataSource {
  Future<Either<AppException, CollectibleComicModel?>> getDigitalAsset(
      String address);
  Future<Either<AppException, List<CollectibleComicModel>>>
      getDigitalCollectibles(String query);
}

class DigitalAssetRemoteDataSource implements DigitalAssetDataSource {
  final NetworkService networkService;

  DigitalAssetRemoteDataSource(this.networkService);

  @override
  Future<Either<AppException, CollectibleComicModel?>> getDigitalAsset(
      String address) async {
    try {
      final response =
          await networkService.get('/$_controllerPath/get/$address');
      return response.fold((exception) => Left(exception), (result) {
        return Right(
          CollectibleComicModel.fromJson(
            result.data,
          ),
        );
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier:
              '${exception.toString()}DigitalAssetRemoteDataSource.getDigitalAsset',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<CollectibleComicModel>>>
      getDigitalCollectibles(String query) async {
    try {
      final response = await networkService
          .get('/$_controllerPath/get/collectible-comic?$query');

      return response.fold((exception) => Left(exception), (result) {
        return Right(
          List<CollectibleComicModel>.from(
            result.data.map(
              (item) => CollectibleComicModel.fromJson(
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
          identifier:
              '${exception.toString()}DigitalAssetRemoteDataSource.getDigitalAssets',
        ),
      );
    }
  }
}
