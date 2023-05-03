import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/referrals/referral_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/validate_wallet_name.dart';
import 'package:d_reader_flutter/core/providers/wallet_name_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/launch_external_url.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/intro/form.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/d_reader_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroView extends HookConsumerWidget {
  final GlobalKey<IntroductionScreenState> _introScreenKey =
      GlobalKey<IntroductionScreenState>();
  final formKey = GlobalKey<FormState>();
  final bool shouldShowInitial;
  IntroView({
    super.key,
    required this.shouldShowInitial,
  });

  PageDecoration _pageDecoration(TextTheme textTheme) {
    return PageDecoration(
      titleTextStyle: textTheme.headlineLarge!.copyWith(
        color: ColorPalette.dReaderYellow100,
      ),
      titlePadding: const EdgeInsets.only(bottom: 16),
      pageColor: ColorPalette.appBackgroundColor,
      imagePadding: const EdgeInsets.only(top: 16),
      imageFlex: 1,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final globalHook = useGlobalState();
    final currentIndex = useState<int>(0);
    final isWalletNameValid = ref.watch(isValidWalletNameValue);
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: IntroductionScreen(
        key: _introScreenKey,
        globalBackgroundColor: ColorPalette.appBackgroundColor,
        bodyPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        showDoneButton: false,
        showNextButton: false,
        showSkipButton: false,
        onChange: (int index) {
          currentIndex.value = index;
        },
        globalFooter: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundedButton(
            text: currentIndex.value == 1 ? 'CONNECT WALLET' : 'NEXT',
            size: const Size(double.infinity, 52),
            onPressed: currentIndex.value != 2 || (isWalletNameValid)
                ? () async {
                    if (currentIndex.value == 0) {
                      _introScreenKey.currentState?.next();
                      SharedPreferences.getInstance().then((value) {
                        value.setBool(Config.hasSeenInitialKey, true);
                      });
                    } else if (currentIndex.value == 1) {
                      globalHook.value =
                          globalHook.value.copyWith(isLoading: true);
                      final result = await ref
                          .read(solanaProvider.notifier)
                          .authorizeAndSignMessage();
                      if (context.mounted) {
                        if (result == 'OK') {
                          Future.delayed(
                            const Duration(
                              milliseconds: 400,
                            ),
                            () {
                              _introScreenKey.currentState?.next();
                            },
                          );
                          globalHook.value =
                              globalHook.value.copyWith(isLoading: false);
                        } else {
                          globalHook.value = globalHook.value.copyWith(
                            isLoading: false,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                result,
                              ),
                            ),
                          );
                        }
                      }
                    } else {
                      if (formKey.currentState!.validate()) {
                        globalHook.value =
                            globalHook.value.copyWith(isLoading: true);
                        final String address = ref
                                .read(environmentProvider)
                                .publicKey
                                ?.toBase58() ??
                            '';
                        final String walletName =
                            ref.read(walletNameProvider).trim();
                        final String referrerName =
                            ref.read(referrerNameProvider).trim();
                        formKey.currentState!.save();
                        await ref.read(
                          updateWalletProvider(
                            UpdateWalletPayload(
                              address: address,
                              name: walletName.trim(),
                              referrer: referrerName.trim(),
                            ),
                          ).future,
                        );
                        globalHook.value =
                            globalHook.value.copyWith(isLoading: false);
                        if (context.mounted) {
                          nextScreenReplace(context, const DReaderScaffold());
                        }
                      }
                    }
                  }
                : null,
            isLoading: globalHook.value.isLoading,
          ),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(7.0),
          activeSize: const Size(20.0, 5.0),
          activeColor: ColorPalette.dReaderYellow100,
          color: Theme.of(context).secondaryHeaderColor,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        pages: [
          PageViewModel(
            title: "Join the digital comic revolution!",
            bodyWidget: Column(
              children: [
                Text(
                  "Help us shape the future of graphic novels and empower artists!",
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
            image: Image.asset('assets/images/splash_screen_1.png'),
            decoration: _pageDecoration(textTheme),
          ),
          PageViewModel(
            title: "Connect with your wallet",
            bodyWidget: Column(
              children: [
                Text(
                  "Connect Solflare or Phantom wallet to securely store your digital comics & goods",
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Don't have a wallet yet?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorPalette.dReaderYellow100,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WalletAppContainer(
                      image: 'assets/images/solflare_logo.png',
                      onTap: () {
                        openExternalApp('com.solflare.mobile');
                      },
                      title: 'Get Solflare',
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    WalletAppContainer(
                      image: 'assets/images/phantom_logo.png',
                      onTap: () {
                        openExternalApp('app.phantom');
                      },
                      title: 'Get Phantom',
                    ),
                  ],
                ),
              ],
            ),
            image: Image.asset(Config.digitalWalletImgPath),
            decoration: _pageDecoration(textTheme),
          ),
          if (ref.watch(environmentProvider).authToken != null &&
              ref.watch(environmentProvider).jwtToken != null) ...[
            PageViewModel(
              title: "Set Your Account",
              bodyWidget: IntroForm(formKey: formKey),
              decoration: PageDecoration(
                titleTextStyle: textTheme.headlineLarge!.copyWith(
                  color: ColorPalette.dReaderYellow100,
                ),
                titlePadding: const EdgeInsets.only(bottom: 16),
                pageColor: ColorPalette.appBackgroundColor,
                bodyAlignment: Alignment.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class WalletAppContainer extends StatelessWidget {
  final String image;
  final String title;
  final Function() onTap;
  const WalletAppContainer({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openExternalApp('com.solflare.mobile');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          border: Border.all(
            color: ColorPalette.boxBackground300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 24,
              height: 24,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
