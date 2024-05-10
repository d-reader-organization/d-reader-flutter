import 'package:d_reader_flutter/features/digital_asset/data/datasource/digital_asset_remote_data_source.dart';
import 'package:d_reader_flutter/features/digital_asset/domain/models/digital_asset.dart';
import 'package:d_reader_flutter/features/digital_asset/domain/repositories/digital_asset_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class DigitalAssetRepositoryImpl implements DigitalAssetRepository {
  final DigitalAssetDataSource dataSource;

  DigitalAssetRepositoryImpl(this.dataSource);
  @override
  Future<Either<AppException, DigitalAssetModel?>> getDigitalAsset(
      String address) {
    return dataSource.getDigitalAsset(address);
  }

  @override
  Future<Either<AppException, List<DigitalAssetModel>>> getDigitalAssets(
      String query) {
    return dataSource.getDigitalAssets(query);
  }
}
