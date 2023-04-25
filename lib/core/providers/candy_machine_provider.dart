import 'package:d_reader_flutter/core/models/candy_machine.dart';
import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/repositories/candy_machine/repository_implementation.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final candyMachineProvider = FutureProvider.autoDispose
    .family<CandyMachineModel?, String>((ref, address) async {
  final result =
      await IoCContainer.resolveContainer<CandyMachineRepositoryImpl>()
          .getCandyMachine(address);
  if (result != null && (result.itemsMinted >= result.supply)) {
    ref.invalidate(comicIssueDetailsProvider);
  }
  return result;
});

final receiptsProvider = FutureProvider.autoDispose
    .family<List<Receipt>, ReceiptsProviderArg>((ref, arg) {
  return IoCContainer.resolveContainer<CandyMachineRepositoryImpl>()
      .getReceipts(
          queryString: '${arg.query}&candyMachineAddress=${arg.address}');
});
