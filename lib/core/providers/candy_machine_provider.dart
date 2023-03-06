import 'package:d_reader_flutter/core/models/candy_machine.dart';
import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/core/repositories/candy_machine/repository_implementation.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:d_reader_flutter/ui/utils/append_default_query_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final candyMachineProvider =
    FutureProvider.family<CandyMachineModel?, String>((ref, address) async {
  return await IoCContainer.resolveContainer<CandyMachineRepositoryImpl>()
      .getCandyMachine(address);
});

final receiptsProvider =
    FutureProvider.family<List<Receipt>, String>((ref, address) async {
  return await IoCContainer.resolveContainer<CandyMachineRepositoryImpl>()
      .getReceipts(
          queryString: appendDefaultQuery('candyMachineAddress=$address'));
});
