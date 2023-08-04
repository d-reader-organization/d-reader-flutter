import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/intro/sign_in.dart';
import 'package:d_reader_flutter/ui/views/intro/sign_up.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InitialIntroScreen extends StatelessWidget {
  const InitialIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          Expanded(
            flex: 2,
            child: IntroImage(
              imagePath: '${Config.introAssetsPath}/splash_1.svg',
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                children: [
                  Text(
                    'Join the comic revolution!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
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
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: RoundedButton(
              text: 'Log in',
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              borderColor: ColorPalette.boxBackground400,
              size: const Size(
                0,
                50,
              ),
              onPressed: () {
                nextScreenPush(context, const SignInScreen());
              },
            ),
          ),
          Expanded(
            child: RoundedButton(
              text: 'Sign up',
              backgroundColor: ColorPalette.dReaderYellow100,
              textColor: Colors.black,
              size: const Size(
                0,
                50,
              ),
              onPressed: () {
                nextScreenPush(context, const SignUpScreen());
              },
            ),
          ),
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
