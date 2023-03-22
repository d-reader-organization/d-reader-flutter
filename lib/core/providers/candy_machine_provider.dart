import 'package:d_reader_flutter/core/models/candy_machine.dart';
import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/core/repositories/candy_machine/repository_implementation.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:d_reader_flutter/ui/utils/append_default_query_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final candyMachineProvider = FutureProvider.autoDispose
    .family<CandyMachineModel?, String>((ref, address) {
  return IoCContainer.resolveContainer<CandyMachineRepositoryImpl>()
      .getCandyMachine(address);
});

final receiptsProvider =
    FutureProvider.autoDispose.family<List<Receipt>, String>((ref, address) {
  return IoCContainer.resolveContainer<CandyMachineRepositoryImpl>()
      .getReceipts(
          queryString: appendDefaultQuery('candyMachineAddress=$address'));
});
