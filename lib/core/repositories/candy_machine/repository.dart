import 'package:d_reader_flutter/core/models/candy_machine.dart';
import 'package:d_reader_flutter/core/models/receipt.dart';

abstract class CandyMachineRepository {
  Future<CandyMachineModel?> getCandyMachine(
    String address,
  );
  Future<List<Receipt>> getReceipts({
    String? queryString,
  });
}
