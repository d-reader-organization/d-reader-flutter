import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/exceptions.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/utils/trigger_bottom_sheet.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/why_need_wallet.dart';
import 'package:d_reader_flutter/ui/widgets/d_reader_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpStep3 extends ConsumerWidget {
  const SignUpStep3({
    super.key,
  });

  Future<void> _handleConnectWallet(WidgetRef ref, BuildContext context) async {
    final globalNotifier = ref.read(globalStateProvider.notifier);
    try {
      final result = await ref
          .read(solanaProvider.notifier)
          .authorizeAndSignMessage(null, () {
        globalNotifier.update(
          (state) => state.copyWith(
            isLoading: true,
          ),
        );
      });
      globalNotifier.update(
        (state) => state.copyWith(
          isLoading: false,
        ),
      );
      if (context.mounted) {
        if (result != 'OK') {
          return showSnackBar(
            context: context,
            text: result,
            backgroundColor: ColorPalette.dReaderRed,
          );
        }
        nextScreenCloseOthers(
          context,
          const DReaderScaffold(),
        );
      }
    } catch (error) {
      globalNotifier.update(
        (state) => state.copyWith(
          isLoading: false,
        ),
      );
      if (context.mounted && error is NoWalletFoundException) {
        return triggerInstallWalletBottomSheet(context);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SvgPicture.asset(
                '${Config.introAssetsPath}/splash_2.svg',
                height: 320,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 32,
                ),
                child: Text(
                  'Connect wallet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Connect with your wallet to store digital comics & other collectibles',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ref.watch(isWalletAvailableProvider).maybeWhen(
                data: (data) {
                  return data
                      ? const SizedBox()
                      : Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorPalette.boxBackground300,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      '${Config.settingsAssetsPath}/light/wallet.svg',
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Text(
                                      'No wallet? Get it here',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const WhyDoINeedWalletWidget(),
                          ],
                        );
                },
                orElse: () {
                  return const SizedBox();
                },
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: RoundedButton(
                  text: 'Skip',
                  backgroundColor: Colors.transparent,
                  textColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  borderColor: ColorPalette.boxBackground400,
                  size: const Size(
                    0,
                    50,
                  ),
                  onPressed: () {
                    nextScreenPush(
                      context,
                      const DReaderScaffold(),
                    );
                  },
                ),
              ),
              Expanded(
                child: RoundedButton(
                  text: ref.watch(isWalletAvailableProvider).maybeWhen(
                    data: (data) {
                      return data ? 'Connect' : 'Install';
                    },
                    orElse: () {
                      return 'Connect';
                    },
                  ),
                  isLoading: ref.watch(globalStateProvider).isLoading,
                  backgroundColor: ColorPalette.dReaderYellow100,
                  textColor: Colors.black,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  size: const Size(
                    0,
                    50,
                  ),
                  onPressed: () async {
                    await _handleConnectWallet(ref, context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
