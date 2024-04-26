import 'package:d_reader_flutter/features/settings/domain/models/spl_token.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class SettingsRemoteSource {
  Future<Either<AppException, List<SplToken>>> getSplTokens();
}

class SettingsRemoteDataSource implements SettingsRemoteSource {
  final NetworkService networkService;

  SettingsRemoteDataSource(this.networkService);

  @override
  Future<Either<AppException, List<SplToken>>> getSplTokens() async {
    try {
      final response = await networkService.get('/settings/spl-token/get');
      return response.fold((exception) => Left(exception), (result) {
        return Right(
          List<SplToken>.from(
            result.data.map(
              (item) => SplToken.fromJson(
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
              '${exception.toString()}SettingsRemoteDataSource.getSplTokens',
        ),
      );
    }
  }
}
