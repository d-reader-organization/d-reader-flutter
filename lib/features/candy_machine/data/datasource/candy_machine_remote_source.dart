import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class CandyMachineDataSource {
  Future<Either<AppException, CandyMachineModel?>> getCandyMachine({
    required String query,
  });
}

class CandyMachineRemoteDataSource implements CandyMachineDataSource {
  final NetworkService networkService;

  CandyMachineRemoteDataSource(this.networkService);

  @override
  Future<Either<AppException, CandyMachineModel?>> getCandyMachine(
      {required String query}) async {
    try {
      final response = await networkService.get('/candy-machine/get?$query');

      return response.fold((exception) => Left(exception), (result) {
        return Right(
          CandyMachineModel.fromJson(
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
              '${exception.toString()}CandyMachineRemoteDataSource.getCandyMachine',
        ),
      );
    }
  }
}
