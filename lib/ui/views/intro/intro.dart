import 'dart:math';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_name_provider.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/launch_external_url.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/views/intro/form.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/d_reader_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroView extends HookConsumerWidget {
  final GlobalKey<IntroductionScreenState> _introScreenKey =
      GlobalKey<IntroductionScreenState>();
  final formKey = GlobalKey<FormState>();
  final bool shouldShowInitial;
  IntroView({
    super.key,
    required this.shouldShowInitial,
  });

  PageDecoration _pageDecoration(bool isInitial) {
    return PageDecoration(
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: isInitial ? 40 : 32,
        fontWeight: FontWeight.w700,
      ),
      titlePadding: const EdgeInsets.only(bottom: 16),
      pageColor: ColorPalette.appBackgroundColor,
      imagePadding: const EdgeInsets.only(top: 16),
      imageFlex: 6,
      bodyFlex: 4,
      imageAlignment: Alignment.topCenter,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalHook = useGlobalState();
    final currentIndex = useState<int>(0);
    final shouldShowSetAccountScreen = useState<bool>(false);
    final isWalletNameValid = ref.watch(isValidWalletNameValue);
    final bool isConnectWalletScreen =
        shouldShowInitial ? currentIndex.value == 1 : currentIndex.value == 0;
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: IntroductionScreen(
        key: _introScreenKey,
        globalBackgroundColor: ColorPalette.appBackgroundColor,
        bodyPadding: const EdgeInsets.symmetric(
          vertical: 2,
        ),
        showDoneButton: false,
        showNextButton: false,
        showSkipButton: false,
        onChange: (int index) {
          currentIndex.value = index;
        },
        globalFooter: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundedButton(
            text: isConnectWalletScreen
                ? 'CONNECT WALLET'
                : shouldShowInitial && currentIndex.value == 0
                    ? 'NEXT'
                    : 'CONFIRM',
            size: const Size(double.infinity, 52),
            onPressed: currentIndex.value != 2 || (isWalletNameValid)
                ? () async {
                    if (isConnectWalletScreen) {
                      globalHook.value =
                          globalHook.value.copyWith(isLoading: true);
                      final result = await ref
                          .read(solanaProvider.notifier)
                          .authorizeAndSignMessage();
                      if (context.mounted) {
                        if (result == 'OK') {
                          // final response =
                          //     await ref.read(myWalletProvider.future);
                          // if (response == null && context.mounted) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Unknown issue has occured.',
                                ),
                              ),
                            );
                            globalHook.value =
                                globalHook.value.copyWith(isLoading: false);
                            return;
                          }
                          final bool isNew = Random().nextInt(100) > 50; // TODO
                          shouldShowSetAccountScreen.value = isNew;
                          Future.delayed(
                            const Duration(
                              milliseconds: 400,
                            ),
                            () async {
                              globalHook.value =
                                  globalHook.value.copyWith(isLoading: false);
                              if (isNew) {
                                _introScreenKey.currentState?.next();
                              } else {
                                nextScreenReplace(
                                  context,
                                  const DReaderScaffold(),
                                );
                              }
                            },
                          );
                        } else {
                          globalHook.value = globalHook.value.copyWith(
                            isLoading: false,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                result,
                              ),
                              backgroundColor: ColorPalette.dReaderRed,
                            ),
                          );
                        }
                      }
                    } else if (currentIndex.value == 0) {
                      _introScreenKey.currentState?.next();
                      await LocalStore.instance
                          .put(Config.hasSeenInitialKey, true);
                    } else {
                      if (formKey.currentState != null &&
                          formKey.currentState!.validate()) {
                        globalHook.value =
                            globalHook.value.copyWith(isLoading: true);

                        formKey.currentState!.save();
                        //TODO update user - check git history

                        globalHook.value =
                            globalHook.value.copyWith(isLoading: false);
                        return showSnackBar(
                          context: context,
                          text: 'TODO',
                          backgroundColor: ColorPalette.dReaderRed,
                          milisecondsDuration: 1000,
                        );
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
          if (shouldShowInitial) ...[
            PageViewModel(
              title: "Join the comic revolution!",
              bodyWidget: const Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Help us shape the future of digital graphic novels and empower artists!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              image: const IntroImage(
                imagePath: '${Config.introAssetsPath}/splash_1.svg',
              ),
              decoration: _pageDecoration(true),
            ),
          ],
          PageViewModel(
            titleWidget: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Connect with\n',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Satoshi',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'your wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            bodyWidget: Column(
              children: [
                const Text(
                  "Connect Solflare or Phantom wallet to store your digital comics & goods",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
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
                const SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () {
                    openUrl(Config.helpCenterLink);
                  },
                  child: const Text(
                    "Have issues setting up?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorPalette.dReaderYellow100,
                    ),
                  ),
                ),
              ],
            ),
            image: const IntroImage(
              imagePath: '${Config.introAssetsPath}/splash_2.svg',
            ),
            decoration: _pageDecoration(false),
          ),
          if (shouldShowSetAccountScreen.value &&
              ref.watch(environmentProvider).jwtToken != null) ...[
            PageViewModel(
              title: "Set your account",
              bodyWidget: IntroForm(formKey: formKey),
              image: const IntroImage(
                imagePath: '${Config.introAssetsPath}/splash_3.svg',
              ),
              decoration: _pageDecoration(false),
            ),
          ],
        ],
      ),
    );
  }
}

class IntroImage extends StatelessWidget {
  final String imagePath;
  const IntroImage({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          foregroundDecoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF565441),
                Color.fromRGBO(86, 84, 65, 0),
              ],
            ),
          ),
        ),
        SvgPicture.asset(
          imagePath,
        )
      ],
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
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
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
