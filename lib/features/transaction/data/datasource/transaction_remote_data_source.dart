import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class TransactionDataSource {
  Future<Either<AppException, List<String>>> mintOneTransaction({
    required String candyMachineAddress,
    required String minterAddress,
    String? label,
  });
  Future<Either<AppException, String?>> useComicIssueAssetTransaction({
    required String digitalAssetAddress,
    required String ownerAddress,
  });
  Future<Either<AppException, String>> listTransaction({
    required String sellerAddress,
    required String mintAccount,
    required int price,
  });
  Future<Either<AppException, List<String>>> buyMultipleItems(
      Map<String, dynamic> query);
  Future<Either<AppException, String>> cancelListingTransaction({
    required String digitalAssetAddress,
  });
}

class TransactionRemoteDataSource implements TransactionDataSource {
  final NetworkService networkService;

  TransactionRemoteDataSource(this.networkService);

  @override
  Future<Either<AppException, List<String>>> buyMultipleItems(
      Map<String, dynamic> query) async {
    try {
      final response = await networkService.get(
        '/transaction/multiple-buy',
        queryParams: query,
      );

      return response.fold((exception) => Left(exception), (result) {
        return Right(List<String>.from(result.data));
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occured',
          statusCode: 500,
          identifier:
              '${exception.toString()}-TransactionRemoteDataSource.buyMultipleItems',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, String>> cancelListingTransaction({
    required String digitalAssetAddress,
  }) async {
    try {
      final response = await networkService
          .get('/transaction/cancel-listing?assetAddress=$digitalAssetAddress');
      return response.fold(
        (exception) => Left(exception),
        (result) => Right(result.data.toString()),
      );
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occured',
          statusCode: 500,
          identifier:
              '${exception.toString()}-TransactionRemoteDataSource.cancelListingTransaction',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, String>> listTransaction({
    required String sellerAddress,
    required String mintAccount,
    required int price,
  }) async {
    try {
      final response = await networkService.get(
        '/transaction/list?sellerAddress=$sellerAddress&mintAccount=$mintAccount&price=$price',
      );
      return response.fold(
        (exception) => Left(exception),
        (result) => Right(
          result.data.toString(),
        ),
      );
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occured',
          statusCode: 500,
          identifier:
              '${exception.toString()}-TransactionRemoteDataSource.listTransaction',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<String>>> mintOneTransaction({
    required String candyMachineAddress,
    required String minterAddress,
    String? label,
  }) async {
    try {
      final response = await networkService.get(
          '/transaction/mint-one?candyMachineAddress=$candyMachineAddress&minterAddress=$minterAddress&label=${label ?? 'public'}');
      return response.fold(
        (exception) => Left(exception),
        (result) {
          return Right(result.data != null ? List.from(result.data) : []);
        },
      );
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occured',
          statusCode: 500,
          identifier:
              '${exception.toString()}-TransactionRemoteDataSource.mintOneTransaction',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, String?>> useComicIssueAssetTransaction({
    required String digitalAssetAddress,
    required String ownerAddress,
  }) async {
    try {
      final response = await networkService.get(
        '/transaction/use-comic-issue-asset?assetAddress=$digitalAssetAddress&ownerAddress=$ownerAddress',
      );
      return response.fold(
        (exception) => Left(exception),
        (result) => Right(
          result.data?.toString(),
        ),
      );
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occured',
          statusCode: 500,
          identifier:
              '${exception.toString()}-TransactionRemoteDataSource.useComicIssueAssetTransaction',
        ),
      );
    }
  }
}
