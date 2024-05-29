import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class TwitterDataSource {
  Future<Either<AppException, String>> assetMintedContent(String assetAddress);
}

class TwitterRemoteDataSource implements TwitterDataSource {
  final NetworkService _networkService;

  TwitterRemoteDataSource(this._networkService);
  @override
  Future<Either<AppException, String>> assetMintedContent(
      String assetAddress) async {
    try {
      final response = await _networkService.get(
          '/twitter/intent/comic-minted?comicAddress=$assetAddress&utmSource=mobile');
      return response.fold((exception) => Left(exception), (result) {
        return Right(
          result.data as String,
        );
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier:
              '${exception.toString()}TwitterRemoteDataSource.assetMintedContent',
        ),
      );
    }
  }
}
