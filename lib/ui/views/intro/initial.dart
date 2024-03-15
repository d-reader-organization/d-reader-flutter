import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            flex: 6,
            child: Container(
              margin: const EdgeInsets.only(top: 24),
              child: SvgPicture.asset(
                '${Config.introAssetsPath}/welcome.svg',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          const Expanded(
            flex: 4,
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
      bottomNavigationBar: Row(
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
                nextScreenPush(
                  context: context,
                  path: RoutePath.signIn,
                  homeSubRoute: false,
                );
              },
              child: Text(
                'Log in',
                style: textTheme.titleSmall?.copyWith(
                  letterSpacing: .2,
                ),
              ),
            ),
          ),
          Expanded(
            child: CustomTextButton(
              backgroundColor: ColorPalette.dReaderYellow100,
              textColor: Colors.black,
              size: const Size(
                0,
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
          ),
        ],
      ),
    );
  }
}
