import 'package:d_reader_flutter/core/models/candy_machine.dart';
import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/core/providers/dio/dio_provider.dart';
import 'package:d_reader_flutter/core/repositories/candy_machine/repository_implementation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'candy_machine_provider.g.dart';

final candyMachineRepositoryProvider = Provider<CandyMachineRepositoryImpl>(
  (ref) {
    return CandyMachineRepositoryImpl(
      client: ref.watch(dioProvider),
    );
  },
);

final receiptsProvider = FutureProvider.autoDispose
    .family<List<Receipt>, ReceiptsProviderArg>((ref, arg) {
  return ref.read(candyMachineRepositoryProvider).getReceipts(
        queryString: '${arg.query}&candyMachineAddress=${arg.address}',
      );
});

@riverpod
Future<CandyMachineModel?> candyMachine(
  Ref ref, {
  required String query,
}) {
  return ref.read(candyMachineRepositoryProvider).getCandyMachine(query: query);
}
