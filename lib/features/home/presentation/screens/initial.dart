import 'dart:io';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_in/sign_in_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InitialIntroScreen extends StatelessWidget {
  const InitialIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 7,
            child: Container(
              margin: const EdgeInsets.only(top: 34),
              child: SvgPicture.asset(
                '${Config.introAssetsPath}/welcome.svg',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          const Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Join the comic revolution!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.2,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Help us shape the future of digital graphic novels and empower artists!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextButton(
            backgroundColor: ColorPalette.dReaderYellow100,
            textColor: Colors.black,
            size: const Size(
              double.infinity,
              50,
            ),
            onPressed: () {
              nextScreenPush(
                context: context,
                path: RoutePath.signUp,
                homeSubRoute: false,
              );
            },
            child: Text(
              'Sign up',
              style: textTheme.titleSmall?.copyWith(
                letterSpacing: .2,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                flex: 2,
                child: Divider(
                  thickness: 1,
                  indent: 12,
                  color: ColorPalette.greyscale200,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'or with',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorPalette.greyscale200,
                      ),
                ),
              ),
              const Expanded(
                flex: 2,
                child: Divider(
                  thickness: 1,
                  endIndent: 12,
                  color: ColorPalette.greyscale200,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Consumer(
            builder: (context, ref, child) {
              return Row(
                children: [
                  Expanded(
                    child: SocialButton(
                      icon: 'assets/icons/google_logo.svg',
                      title: 'Google',
                      onPressed: () {
                        ref
                            .read(signInControllerProvider.notifier)
                            .googleSignIn(
                          onSuccess: () {
                            nextScreenCloseOthers(
                              context: context,
                              path: RoutePath.home,
                            );
                          },
                          onFail: (String message) {
                            showSnackBar(
                              context: context,
                              text: message,
                              backgroundColor: ColorPalette.dReaderRed,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  if (Platform.isIOS) ...[
                    Expanded(
                      child: SocialButton(
                        icon: 'assets/icons/apple_logo.svg',
                        title: 'Apple',
                        onPressed: () {
                          // handle apple login
                        },
                      ),
                    ),
                  ]
                ],
              );
            },
          ),
          const SizedBox(
            height: 12,
          ),
          RichText(
            text: TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  nextScreenPush(
                    context: context,
                    path: RoutePath.signIn,
                    homeSubRoute: false,
                  );
                },
              text: 'Already have account? ',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: ColorPalette.greyscale200),
              children: <TextSpan>[
                TextSpan(
                  text: 'Log in',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      nextScreenPush(
                        context: context,
                        path: RoutePath.signIn,
                        homeSubRoute: false,
                      );
                    },
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: ColorPalette.dReaderYellow100),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String icon, title;
  final Function() onPressed;
  const SocialButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      backgroundColor: Colors.transparent,
      textColor: Colors.white,
      borderColor: ColorPalette.greyscale300,
      size: const Size(
        double.infinity,
        50,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon),
          const SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  letterSpacing: .2,
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}
