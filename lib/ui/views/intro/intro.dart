import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/validate_wallet_name.dart';
import 'package:d_reader_flutter/core/providers/wallet_name_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/intro/form.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/d_reader_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroView extends HookConsumerWidget {
  final GlobalKey<IntroductionScreenState> _introScreenKey =
      GlobalKey<IntroductionScreenState>();
  final formKey = GlobalKey<FormState>();
  IntroView({Key? key}) : super(key: key);

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
    final validateNameProvider =
        ref.watch(validateWalletNameProvider(ref.read(walletNameProvider)));
    final isInvalidName =
        validateNameProvider.value != null && !validateNameProvider.value!;
    final bool shouldFreeze = currentIndex.value == 1 &&
        (ref.watch(walletNameProvider).isEmpty || isInvalidName);
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: IntroductionScreen(
        key: _introScreenKey,
        globalBackgroundColor: ColorPalette.appBackgroundColor,
        bodyPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        showDoneButton: false,
        showNextButton: false,
        freeze: shouldFreeze,
        showSkipButton: false,
        onChange: (int index) {
          currentIndex.value = index;
        },
        globalFooter: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundedButton(
            text: currentIndex.value == 2 ? 'CONNECT WALLET' : 'NEXT',
            size: const Size(double.infinity, 52),
            onPressed: shouldFreeze
                ? null
                : () async {
                    if (currentIndex.value == 0) {
                      _introScreenKey.currentState?.next();
                    } else if (currentIndex.value == 1) {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        _introScreenKey.currentState?.next();
                      }
                    } else {
                      globalHook.value =
                          globalHook.value.copyWith(isLoading: true);
                      final result = await ref
                          .read(solanaProvider.notifier)
                          .authorizeAndSignMessage();
                      if (result == false && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Failed to sign a message.',
                            ),
                          ),
                        );
                        globalHook.value = globalHook.value
                            .copyWith(isLoading: false, showSplash: false);
                        return;
                      }
                      globalHook.value =
                          globalHook.value.copyWith(isLoading: false);
                      if (context.mounted) {
                        nextScreenReplace(context, const DReaderScaffold());
                      }
                    }
                  },
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
                    Container(
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
                            'assets/images/solflare_logo.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'Get Solflare',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
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
                            'assets/images/phantom_logo.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'Get Phantom',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            image: Image.asset(Config.digitalWalletImgPath),
            decoration: _pageDecoration(textTheme),
          ),
        ],
      ),
    );
  }
}
