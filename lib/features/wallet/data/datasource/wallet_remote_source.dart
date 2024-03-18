import 'package:d_reader_flutter/features/wallet/domain/models/wallet.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class WalletDataSource {
  Future<Either<AppException, bool>> syncWallet(String address);
  Future<Either<AppException, WalletModel>> updateWallet({
    required String address,
    required String label,
  });
}

class WalletRemoteDataSource implements WalletDataSource {
  final NetworkService networkService;

  WalletRemoteDataSource(this.networkService);

  @override
  Future<Either<AppException, bool>> syncWallet(String address) {
    return networkService.get('/wallet/sync/$address').then((result) {
      return result.fold(
          (exception) => Left(exception), (right) => const Right(true));
    });
  }

  @override
  Future<Either<AppException, WalletModel>> updateWallet({
    required String address,
    required String label,
  }) async {
    try {
      final result = await networkService.patch('/wallet/update/$address');
      return result.fold((exception) {
        return Left(exception);
      }, (response) {
        return Right(WalletModel.fromJson(response.data));
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier:
              '${exception.toString()}WalletRemoteDataSource.updateWallet',
        ),
      );
    }
  }
}
