import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/notifiers/candy_machine_notifier.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/about/mint_info_container.dart';
import 'package:d_reader_flutter/features/settings/domain/models/spl_token.dart';
import 'package:d_reader_flutter/features/settings/presentation/providers/spl_tokens.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
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
  return response.fold((exception) {
    return null;
  }, (result) {
    if (result != null) {
      ref.read(candyMachineStateProvider.notifier).update((state) => result);
      final priorSplToken = getSplTokenWithHighestPriority(splTokens);
      final selectedCoupon = getActiveCoupon(
            coupons: result.coupons,
            selectedSplTokenAddress: priorSplToken.address,
          ) ??
          result.coupons.first;
      ref
          .read(candyMachineNotifierProvider.notifier)
          .updateSelectedCoupon(selectedCoupon);
      final selectedCurrency = selectedCoupon.prices
          .firstWhere((price) => price.splTokenAddress == solAddress);
      ref
          .read(candyMachineNotifierProvider.notifier)
          .updateSelectedCurrency(selectedCurrency);
    }
    return result;
  });
}

final activeSplToken = StateProvider.autoDispose<SplToken?>(
  (ref) {
    return ref
        .watch(splTokensProvider)
        .value
        ?.firstWhere((element) => element.priority == splTokenHighestPriority);
  },
);

final timeUntilMintStarts = StateProvider.autoDispose<String>(
  (ref) {
    final candyMachineCoupon =
        ref.read(candyMachineNotifierProvider).selectedCoupon;
    return Formatter.formatDateInRelative(candyMachineCoupon?.startsAt);
  },
);

final mintStatusesProvider = StateProvider.autoDispose<(bool, bool)>(
  (ref) {
    final candyMachineGroup =
        ref.watch(candyMachineNotifierProvider).selectedCoupon;

    return candyMachineGroup == null
        ? (false, false)
        : getMintStatuses(candyMachineGroup);
  },
);
