import 'package:d_reader_flutter/core/providers/comic_issue/provider.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/receipt.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/ui/utils/candy_machine_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'candy_machine_provider.g.dart';

final receiptsProvider =
    FutureProvider.autoDispose.family<List<Receipt>, ReceiptsProviderArg>(
  (ref, arg) {
    return ref
        .read(candyMachineRepositoryProvider)
        .getReceipts(
          queryString: '${arg.query}&candyMachineAddress=${arg.address}',
        )
        .then(
          (value) => value.fold(
            (exception) {
              throw exception;
            },
            (data) => data,
          ),
        );
  },
);

final candyMachineStateProvider = StateProvider<CandyMachineModel?>(
  (ref) {
    return null;
  },
);

@riverpod
Future<CandyMachineModel?> candyMachine(
  Ref ref, {
  required String query,
}) async {
  final response = await ref
      .read(candyMachineRepositoryProvider)
      .getCandyMachine(query: query);

  return response.fold((exception) => null, (result) {
    if (result != null) {
      ref.read(candyMachineStateProvider.notifier).update((state) => result);
      final activeGroup = getActiveGroup(result.groups);
      ref.read(activeCandyMachineGroup.notifier).update((state) => activeGroup);
      ref
          .read(expandedCandyMachineGroup.notifier)
          .update((state) => activeGroup?.label ?? '');
    }
    return result;
  });
}
