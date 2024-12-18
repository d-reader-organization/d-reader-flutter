import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine_coupon.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/notifiers/candy_machine_notifier.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/about/group_with_currency.dart';
import 'package:d_reader_flutter/features/settings/presentation/providers/spl_tokens.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/mint_price_widget.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

String _mintSupplyText({required int itemsMinted, required int totalSupply}) {
  return '${itemsMinted > totalSupply ? totalSupply : itemsMinted}/$totalSupply';
}

String _myMintSupplyText({required int itemsMinted, int? supply}) {
  return 'You minted: $itemsMinted/${supply ?? '∞'}';
}

(bool, bool) getMintStatuses(CandyMachineCoupon candyMachineCoupon) {
  bool isActive = candyMachineCoupon.startsAt == null ||
      candyMachineCoupon.startsAt!
          .isBefore(DateTime.now().add(const Duration(seconds: 1)));
  bool isEnded = candyMachineCoupon.expiresAt != null &&
      candyMachineCoupon.expiresAt!.isBefore(DateTime.now());

  return (isActive, isEnded);
}

bool _shouldInitTicker(DateTime mintStartDate) {
  final currentDate = DateTime.now();
  final difference = mintStartDate.difference(currentDate);
  return difference.inDays < 1 &&
      difference.inHours < 1 &&
      difference.inSeconds > 1;
}

class MintInfoContainer extends ConsumerStatefulWidget {
  final List<CandyMachineCoupon> candyMachineCoupons;
  final int totalSupply;
  const MintInfoContainer({
    super.key,
    required this.candyMachineCoupons,
    required this.totalSupply,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MintInfoContainerState();
}

class _MintInfoContainerState extends ConsumerState<MintInfoContainer>
    with SingleTickerProviderStateMixin {
  Ticker? _ticker;

  @override
  void initState() {
    super.initState();
    final candyMachineCoupon =
        ref.read(candyMachineNotifierProvider).selectedCoupon;
    if (candyMachineCoupon?.startsAt != null &&
        _shouldInitTicker(candyMachineCoupon!.startsAt!)) {
      _initTicker();
    }
  }

  void _initTicker() {
    _ticker = createTicker(
      (elapsed) {
        final candyMachineGroup =
            ref.read(candyMachineNotifierProvider).selectedCoupon!;
        final (isActive, isEnded) = getMintStatuses(candyMachineGroup);

        ref.read(mintStatusesProvider.notifier).update(
              (state) => (isActive, isEnded),
            );
        ref.read(timeUntilMintStarts.notifier).update(
              (state) =>
                  Formatter.formatDateInRelative(candyMachineGroup.startsAt),
            );
        if (isActive) {
          _ticker?.stop();
        }
      },
    );
    _ticker?.start();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCandyMachineCoupon =
        ref.watch(candyMachineNotifierProvider).selectedCoupon;
    if (selectedCandyMachineCoupon == null) {
      return const SizedBox();
    }
    final candyMachineState = ref.watch(candyMachineStateProvider);
    final splTokens = ref.watch(splTokensProvider);
    final displayDropdown = selectedCandyMachineCoupon.prices.length > 1;
    final bool isMintActive = ref.watch(mintStatusesProvider).$1;
    final mintPrice =
        ref.watch(candyMachineNotifierProvider.notifier).getMintPrice();
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
                    title: _HeadingRow(
                      candyMachineCoupon: selectedCandyMachineCoupon,
                      suffix: const MintPriceWidget(),
                    ),
                    children: selectedCandyMachineCoupon.prices.map((price) {
                      final splToken = splTokens.value?.firstWhere((element) =>
                          element.address == price.splTokenAddress);
                      if (splToken == null) {
                        return const SizedBox();
                      }
                      return CouponWithCurrencyRow(
                        splToken: splToken,
                        mintPrice: price.mintPrice,
                        prices: selectedCandyMachineCoupon.prices,
                      );
                    }).toList(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _HeadingRow(
                    candyMachineCoupon: selectedCandyMachineCoupon,
                    suffix: PriceWidget(
                      price: mintPrice > 0
                          ? Formatter.formatPriceByCurrency(
                              mintPrice: mintPrice,
                              splToken: ref.watch(activeSplToken),
                            )
                          : null,
                    ),
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
          _MintStatus(
            candyMachine: candyMachineState,
            candyMachineCoupon: selectedCandyMachineCoupon,
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

class _HeadingRow extends ConsumerWidget {
  final CandyMachineCoupon candyMachineCoupon;
  final Widget suffix;
  const _HeadingRow({
    required this.candyMachineCoupon,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final (isMintActive, isMintEnded) = ref.watch(mintStatusesProvider);
    return Row(
      key: key,
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
                    backgroundColor: ColorPalette.dReaderYellow100,
                    radius: 6,
                  )
                : const SizedBox(),
            const SizedBox(
              width: 4,
            ),
            Consumer(
              builder: (context, ref, child) {
                return Text(
                  isMintActive
                      ? 'Live'
                      : !isMintEnded
                          ? 'Starts in ${ref.watch(timeUntilMintStarts)}'
                          : 'Ended',
                  style: textTheme.titleMedium?.copyWith(
                    color: isMintActive
                        ? ColorPalette.dReaderYellow100
                        : !isMintEnded
                            ? ColorPalette.dReaderYellow300
                            : ColorPalette.greyscale200,
                  ),
                );
              },
            )
          ],
        ),
        suffix,
      ],
    );
  }
}

class _MintStatus extends StatelessWidget {
  final CandyMachineModel? candyMachine;
  final CandyMachineCoupon candyMachineCoupon;
  const _MintStatus({
    required this.candyMachine,
    required this.candyMachineCoupon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      key: key,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _myMintSupplyText(
            itemsMinted: candyMachineCoupon.stats.itemsMinted,
            supply: candyMachineCoupon.numberOfRedemptions,
          ),
          style: textTheme.bodySmall?.copyWith(
            color: ColorPalette.greyscale100,
          ),
        ),
        Text(
          _mintSupplyText(
            itemsMinted: candyMachine?.itemsMinted ?? 0,
            totalSupply: candyMachine?.supply ?? 0,
          ),
          style: textTheme.bodySmall?.copyWith(
            color: ColorPalette.greyscale100,
          ),
        ),
      ],
    );
  }
}

class _ComicVaultContainer extends ConsumerWidget {
  const _ComicVaultContainer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
        trailing: const SizedBox(),
        backgroundColor: ColorPalette.greyscale400,
        collapsedBackgroundColor: ColorPalette.greyscale400,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        childrenPadding: const EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 8,
          top: 0,
        ),
        title: Row(
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
        children: [
          Text(
            'Comic Vault stores portion of the supply of each issue to later use in giveaways & other activities where we reward loyal users',
            style: textTheme.bodySmall?.copyWith(
              color: ColorPalette.greyscale100,
            ),
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
