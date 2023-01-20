import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/providers/auth_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/d_reader_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroView extends HookConsumerWidget {
  final GlobalKey<IntroductionScreenState> _introScreenKey =
      GlobalKey<IntroductionScreenState>();
  IntroView({Key? key}) : super(key: key);

  PageDecoration _pageDecoration(TextTheme textTheme) {
    return PageDecoration(
      titleTextStyle: textTheme.headlineLarge!.copyWith(
        color: ColorPalette.dReaderYellow100,
      ),
      bodyAlignment: Alignment.center,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final globalHook = useGlobalState();
    final currentIndex = useState<int>(0);
    final bool isFirstScreen = currentIndex.value == 0;
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: IntroductionScreen(
        key: _introScreenKey,
        globalBackgroundColor: ColorPalette.appBackgroundColor,
        bodyPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        showDoneButton: false,
        showNextButton: false,
        onChange: (int index) {
          currentIndex.value = index;
        },
        globalFooter: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundedButton(
            text: isFirstScreen ? 'NEXT' : 'CONNECT WALLET',
            size: const Size(double.infinity, 52),
            onPressed: () async {
              if (isFirstScreen) {
                _introScreenKey.currentState?.next();
              } else {
                globalHook.value = globalHook.value.copyWith(isLoading: true);
                final result = await ref
                    .read(solanaProvider.notifier)
                    .authorizeAndSignMessage();
                if (result == null) {
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
                final String token = await ref
                    .read(solanaProvider.notifier)
                    .getTokenAfterSigning(result);
                await ref.read(authProvider.notifier).storeToken(token);
                globalHook.value = globalHook.value.copyWith(isLoading: false);
                nextScreenReplace(context, const DReaderScaffold());
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
            image: Image.asset(Config.digitalWalletImgPath),
            decoration: _pageDecoration(textTheme),
          ),
          PageViewModel(
            title: "Connect with your wallet",
            bodyWidget: Column(
              children: [
                Text(
                  "Connect to any wallet to securely store youd digital comics & goods",
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                RichText(
                  text: TextSpan(
                      style: textTheme.bodyMedium,
                      children: <TextSpan>[
                        const TextSpan(
                          text: "Don't have a wallet yet? ",
                        ),
                        TextSpan(
                          text: "Get one here!",
                          style: textTheme.bodyMedium?.copyWith(
                            color: ColorPalette.dReaderYellow100,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ]),
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
