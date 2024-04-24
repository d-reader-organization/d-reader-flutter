import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine_group.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/about/group_with_currency.dart';
import 'package:d_reader_flutter/features/settings/presentation/providers/spl_tokens.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/mint_price_widget.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/solana_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

String mintNumbersText({required int itemsMinted, required int totalSupply}) {
  return '${itemsMinted > totalSupply ? totalSupply : itemsMinted}/$totalSupply';
}

String myMintNumbersText({required int itemsMinted, int? supply}) {
  return 'You minted: $itemsMinted/${supply ?? '∞'}';
}

(bool, bool) getMintStatuses(CandyMachineGroupModel candyMachineGroup) {
  bool isActive = candyMachineGroup.startDate == null ||
      candyMachineGroup.startDate!.isBefore(DateTime.now());

  bool isEnded = candyMachineGroup.endDate != null &&
      candyMachineGroup.endDate!.isBefore(DateTime.now());

  return (isActive, isEnded);
}

class MintInfoContainer extends ConsumerWidget {
  final List<CandyMachineGroupModel> candyMachineGroups;
  final int totalSupply;
  const MintInfoContainer({
    super.key,
    required this.candyMachineGroups,
    required this.totalSupply,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final candyMachineGroup = ref.watch(selectedCandyMachineGroup);
    if (candyMachineGroup == null) {
      return const SizedBox();
    }
    final (isMintActive, isMintEnded) = getMintStatuses(candyMachineGroup);

    final candyMachineState = ref.watch(candyMachineStateProvider);
    final splTokens = ref.watch(splTokensProvider);
    final displayDropdown = candyMachineGroups.length > 1 &&
        splTokens.value != null &&
        splTokens.value!.isNotEmpty;
    return _DecoratedContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          displayDropdown
              ? Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    childrenPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Mint',
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            isMintActive
                                ? const CircleAvatar(
                                    backgroundColor:
                                        ColorPalette.dReaderYellow100,
                                    radius: 6,
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              isMintActive
                                  ? 'Live'
                                  : !isMintEnded
                                      ? 'Starts in ${Formatter.formatDateInRelative(candyMachineGroup.startDate)}'
                                      : 'Ended',
                              style: textTheme.titleMedium?.copyWith(
                                color: isMintActive
                                    ? ColorPalette.dReaderYellow100
                                    : !isMintEnded
                                        ? ColorPalette.dReaderYellow300
                                        : ColorPalette.greyscale200,
                              ),
                            ),
                          ],
                        ),
                        const MintPriceWidget(),
                      ],
                    ),
                    children: candyMachineGroups.map((group) {
                      final splToken = splTokens.value?.firstWhere((element) =>
                          element.address == group.splTokenAddress);
                      if (splToken == null) {
                        return const SizedBox();
                      }
                      return GroupWithCurrencyRow(
                        splToken: splToken,
                        mintPrice: group.mintPrice,
                        groups: candyMachineGroups,
                      );
                    }).toList(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Mint',
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          isMintActive
                              ? const CircleAvatar(
                                  backgroundColor:
                                      ColorPalette.dReaderYellow100,
                                  radius: 6,
                                )
                              : const SizedBox(),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            isMintActive
                                ? 'Live'
                                : !isMintEnded
                                    ? 'Starts in ${Formatter.formatDateInRelative(candyMachineGroup.startDate)}'
                                    : 'Ended',
                            style: textTheme.titleMedium?.copyWith(
                              color: isMintActive
                                  ? ColorPalette.dReaderYellow100
                                  : !isMintEnded
                                      ? ColorPalette.dReaderYellow300
                                      : ColorPalette.greyscale200,
                            ),
                          ),
                        ],
                      ),
                      SolanaPrice(
                        price: candyMachineGroup.mintPrice > 0
                            ? Formatter.formatPriceWithSignificant(
                                candyMachineGroup.mintPrice.round(),
                              )
                            : null,
                      )
                    ],
                  ),
                ),
          SizedBox(
            height: displayDropdown ? 12 : 24,
          ),
          if (isMintActive) ...[
            LinearProgressIndicator(
              backgroundColor: ColorPalette.greyscale400,
              minHeight: 8,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  ColorPalette.dReaderYellow100),
              value: (candyMachineState?.itemsMinted ?? 0) /
                  (candyMachineState?.supply ?? 0),
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                myMintNumbersText(
                  itemsMinted: candyMachineGroup.user?.itemsMinted ??
                      candyMachineGroup.wallet?.itemsMinted ??
                      0,
                  supply: candyMachineGroup.user?.supply ??
                      candyMachineGroup.wallet?.supply,
                ),
                style: textTheme.bodySmall?.copyWith(
                  color: ColorPalette.greyscale100,
                ),
              ),
              Text(
                mintNumbersText(
                  itemsMinted: candyMachineState?.itemsMinted ?? 0,
                  totalSupply: candyMachineState?.supply ?? 0,
                ),
                style: textTheme.bodySmall?.copyWith(
                  color: ColorPalette.greyscale100,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const _ComicVaultContainer(),
        ],
      ),
    );
  }
}

class _ComicVaultContainer extends ConsumerWidget {
  const _ComicVaultContainer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorPalette.greyscale400,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/lock.svg',
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Comic Vault',
                style: textTheme.bodySmall?.copyWith(
                  color: ColorPalette.greyscale100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DecoratedContainer extends StatelessWidget {
  final Widget child;
  const _DecoratedContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: ColorPalette.greyscale500,
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}
