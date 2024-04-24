import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine_group.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/features/settings/domain/models/spl_token.dart';
import 'package:d_reader_flutter/features/settings/presentation/providers/spl_tokens.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'candy_machine_providers.g.dart';

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
  final splTokens = await ref.read(splTokensProvider.future);
  return response.fold((exception) => null, (result) {
    if (result != null) {
      ref.read(candyMachineStateProvider.notifier).update((state) => result);
      final priorSplToken = getSplTokenWithHighestPriority(splTokens);
      final selectedGroup = getSelectedGroup(
            groups: result.groups,
            selectedSplTokenAddress: priorSplToken.address,
          ) ??
          result.groups.first;
      ref
          .read(selectedCandyMachineGroup.notifier)
          .update((state) => selectedGroup);
    }
    return result;
  });
}

final selectedCandyMachineGroup =
    StateProvider.autoDispose<CandyMachineGroupModel?>((ref) {
  return null;
});

final activeSplToken = StateProvider.autoDispose<SplToken?>(
  (ref) {
    return ref
        .watch(splTokensProvider)
        .value
        ?.firstWhere((element) => element.priority == splTokenHighestPriority);
  },
);
