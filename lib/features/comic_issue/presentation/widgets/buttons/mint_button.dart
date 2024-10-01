import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/notifiers/candy_machine_notifier.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/buttons/transaction_button.dart';
import 'package:d_reader_flutter/features/transaction/presentation/providers/mint/notifier/mint_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/solana_providers.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _buttonText = 'Mint';

class MintButton extends ConsumerWidget {
  final String activeCandyMachineAddress;

  const MintButton({
    super.key,
    required this.activeCandyMachineAddress,
  });

  void _showWalkthroughDialog({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    triggerWalkthroughDialog(
      context: context,
      bottomWidget: GestureDetector(
        onTap: () {
          context.pop();
        },
        child: Text(
          'Cancel',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                decoration: TextDecoration.underline,
              ),
        ),
      ),
      onSubmit: () {
        context.pop();
        triggerInstallWalletBottomSheet(context);
      },
      assetPath: '$walkthroughAssetsPath/install_wallet.jpg',
      title: 'Install a wallet',
      subtitle:
          'To buy a digital asset you need to have a digital wallet installed first. Click “Next” to set up a wallet!',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      mintNotifierProvider,
      (previous, next) {
        next.whenOrNull(
          failed: (message) => showSnackBar(context: context, text: message),
          success: (message) => nextScreenPush(
            context: context,
            path: RoutePath.mintLoadingAnimation,
          ),
          showDialog: () => triggerVerificationDialog(context, ref),
          failedWithException: (exception) {
            if (exception is NoWalletFoundException) {
              _showWalkthroughDialog(context: context, ref: ref);
            } else if (exception is LowPowerModeException) {
              triggerLowPowerModeDialog(context);
            }
            showSnackBar(
              context: context,
              text: exception.message,
              backgroundColor: ColorPalette.dReaderRed,
            );
          },
        );
      },
    );

    return ref.watch(mintNotifierProvider).maybeWhen(
          processing: () => _MintButton(
            activeCandyMachineAddress: activeCandyMachineAddress,
            isLoading: true,
          ),
          orElse: () => _MintButton(
            activeCandyMachineAddress: activeCandyMachineAddress,
            isLoading: false,
          ),
        );
  }
}

class _MintButton extends ConsumerWidget {
  final bool isLoading;
  final String activeCandyMachineAddress;
  const _MintButton({
    required this.activeCandyMachineAddress,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (isMintActive, isEnded) = ref.watch(mintStatusesProvider);
    final shouldDisableMintButton = !isMintActive && !isEnded;
    return TransactionButton(
      isLoading: isLoading,
      isDisabled: shouldDisableMintButton,
      onPressed: ref.watch(isOpeningSessionProvider)
          ? null
          : () {
              ref
                  .read(mintNotifierProvider.notifier)
                  .mint(activeCandyMachineAddress);
            },
      text: _buttonText,
      price: ref.watch(candyMachineNotifierProvider.notifier).getMintPrice(),
      isMultiGroup:
          (ref.watch(candyMachineStateProvider)?.coupons.length ?? 0) > 1,
    );
  }
}
