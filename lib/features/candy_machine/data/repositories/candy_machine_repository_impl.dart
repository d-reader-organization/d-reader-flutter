import 'package:d_reader_flutter/features/candy_machine/data/datasource/candy_machine_remote_source.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/repositories/candy_machine_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class CandyMachineRepositoryImpl implements CandyMachineRepository {
  final CandyMachineDataSource dataSource;

  CandyMachineRepositoryImpl(this.dataSource);

  @override
  Future<Either<AppException, CandyMachineModel?>> getCandyMachine(
      {required String query}) {
    return dataSource.getCandyMachine(query: query);
  }
}
