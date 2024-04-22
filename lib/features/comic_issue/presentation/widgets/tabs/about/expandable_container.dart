import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine_group.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
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

class MintInfoContainer extends ConsumerWidget {
  final CandyMachineGroupModel candyMachineGroup;
  final int totalSupply;
  const MintInfoContainer({
    super.key,
    required this.candyMachineGroup,
    required this.totalSupply,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final isFutureMint = candyMachineGroup.startDate != null &&
        candyMachineGroup.startDate!.isAfter(DateTime.now());
    final candyMachineState = ref.watch(candyMachineStateProvider);
    return GestureDetector(
      onTap: () {
        ref.read(expandedCandyMachineGroup.notifier).update((state) =>
            state != candyMachineGroup.label ? candyMachineGroup.label : '');
      },
      child: _DecoratedContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
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
                    candyMachineGroup.isActive
                        ? const CircleAvatar(
                            backgroundColor: ColorPalette.dReaderYellow100,
                            radius: 6,
                          )
                        : const SizedBox(),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      candyMachineGroup.isActive
                          ? 'Live'
                          : isFutureMint
                              ? 'Starts in ${Formatter.formatDateInRelative(candyMachineGroup.startDate)}'
                              : 'Ended',
                      style: textTheme.titleMedium?.copyWith(
                        color: candyMachineGroup.isActive
                            ? ColorPalette.dReaderYellow100
                            : isFutureMint
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
            const SizedBox(
              height: 24,
            ),
            if (candyMachineGroup.isActive) ...[
              LinearProgressIndicator(
                backgroundColor: ColorPalette.greyscale400,
                minHeight: 8,
                valueColor: AlwaysStoppedAnimation<Color>(
                  candyMachineGroup.isActive
                      ? ColorPalette.dReaderYellow100
                      : ColorPalette.greyscale200,
                ),
                value: candyMachineGroup.itemsMinted / candyMachineGroup.supply,
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
                  candyMachineGroup.label == publicGroupLabel
                      ? mintNumbersText(
                          itemsMinted: candyMachineState?.itemsMinted ??
                              candyMachineGroup.itemsMinted,
                          totalSupply: candyMachineState?.supply ??
                              candyMachineGroup.supply)
                      : mintNumbersText(
                          itemsMinted: candyMachineGroup.itemsMinted,
                          totalSupply: candyMachineGroup.supply,
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
      child: GestureDetector(
        onTap: () {
          ref
              .read(expandedCandyMachineGroup.notifier)
              .update((state) => state == 'ComicVault' ? '' : 'ComicVault');
        },
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
            // Column(
            //   children: [
            //     const SizedBox(
            //       height: 8,
            //     ),
            //     Text(
            //       'Comic Vault stores portion of the supply of each issue to later use in giveaways & other activities where we reward loyal users',
            //       style: textTheme.bodySmall?.copyWith(
            //         color: ColorPalette.greyscale100,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorPalette.greyscale500,
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}
