import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_notifier.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/why_need_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpStep3 extends ConsumerWidget {
  const SignUpStep3({super.key});

  Future<void> _handleConnectWallet(WidgetRef ref, BuildContext context) async {
    await ref.read(walletControllerProvider.notifier).connectWallet(
      onSuccess: () {
        nextScreenCloseOthers(
          context: context,
          path: RoutePath.home,
        );
      },
      onFail: (String result) {
        showSnackBar(
          context: context,
          text: result,
          backgroundColor: ColorPalette.dReaderRed,
        );
      },
      onError: (exception) {
        triggerLowPowerOrNoWallet(
          context,
          exception,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return PopScope(
      canPop: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SvgPicture.asset(
                '${Config.introAssetsPath}/wallet.svg',
                fit: BoxFit.fitWidth,
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
                height: 8,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Connect with your wallet to store digital comics & other collectibles',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
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
                            GestureDetector(
                              onTap: () async {
                                await _handleConnectWallet(ref, context);
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorPalette.greyscale400,
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
                child: CustomTextButton(
                  backgroundColor: Colors.transparent,
                  textColor: Colors.white,
                  borderColor: ColorPalette.greyscale300,
                  size: const Size(
                    0,
                    50,
                  ),
                  onPressed: () {
                    nextScreenCloseOthers(
                      context: context,
                      path: RoutePath.home,
                    );
                  },
                  child: Text(
                    'Skip',
                    style: textTheme.titleSmall,
                  ),
                ),
              ),
              Expanded(
                child: CustomTextButton(
                  isLoading: ref.watch(globalStateProvider).isLoading,
                  backgroundColor: ColorPalette.dReaderYellow100,
                  textColor: Colors.black,
                  size: const Size(
                    0,
                    50,
                  ),
                  onPressed: () async {
                    await _handleConnectWallet(ref, context);
                  },
                  child: Text(
                    ref.watch(isWalletAvailableProvider).maybeWhen(
                      data: (data) {
                        return data ? 'Connect' : 'Install';
                      },
                      orElse: () {
                        return 'Connect';
                      },
                    ),
                    style: textTheme.titleSmall?.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
