import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/receipt.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class CandyMachineRepository {
  Future<Either<AppException, CandyMachineModel?>> getCandyMachine({
    required String query,
  });
  Future<Either<AppException, List<Receipt>>> getReceipts({
    String? queryString,
  });
}
