import 'package:d_reader_flutter/features/digital_asset/domain/models/digital_asset.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class DigitalAssetRepository {
  Future<Either<AppException, DigitalAssetModel?>> getDigitalAsset(
      String address);
  Future<Either<AppException, List<DigitalAssetModel>>> getDigitalAssets(
      String query);
}
