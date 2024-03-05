import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/receipt.dart';

abstract class CandyMachineRepository {
  Future<CandyMachineModel?> getCandyMachine({
    required String query,
  });
  Future<List<Receipt>> getReceipts({
    String? queryString,
  });
}
