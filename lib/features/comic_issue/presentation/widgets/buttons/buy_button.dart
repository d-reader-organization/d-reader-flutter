import 'package:d_reader_flutter/features/auction_house/presentation/providers/auction_house_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/buttons/transaction_button.dart';
import 'package:d_reader_flutter/features/transaction/presentation/providers/buy/notifier/buy_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/solana_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _buttonText = 'Buy';

class BuyButton extends ConsumerWidget {
  const BuyButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      buyNotifierProvider,
      (previous, next) {
        next.whenOrNull(
          failed: (message) => showSnackBar(context: context, text: message),
          success: (message) => showSnackBar(
            context: context,
            text: message,
            backgroundColor: ColorPalette.dReaderGreen,
          ),
          failedWithException: (exception) {
            triggerLowPowerOrNoWallet(
              context,
              exception,
            );
          },
        );
      },
    );
    return ref.watch(buyNotifierProvider).maybeWhen(
          processing: () => const _BuyButton(
            isLoading: true,
          ),
          orElse: () => const _BuyButton(
            isLoading: false,
          ),
        );
  }
}

class _BuyButton extends ConsumerWidget {
  final bool isLoading;
  const _BuyButton({
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TransactionButton(
      isLoading: isLoading,
      onPressed: ref.read(selectedListingsProvider).isNotEmpty &&
              !ref.watch(isOpeningSessionProvider)
          ? ref.read(buyNotifierProvider.notifier).buy
          : null,
      text: _buttonText,
      price: ref.watch(selectedListingsPrice),
      isListing: true,
    );
  }
}
