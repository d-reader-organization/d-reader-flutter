import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/intro/intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInFadeOut;
  bool shouldShowInitial = true;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      shouldShowInitial = !(value.getBool(Config.hasSeenInitialKey) ?? false);
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _fadeInFadeOut =
        Tween<double>(begin: 0.2, end: 1.5).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        nextScreenReplace(
          context,
          IntroView(
            shouldShowInitial: shouldShowInitial,
          ),
        );
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeInFadeOut,
          child: SvgPicture.asset(Config.logoAlphaPath),
        ),
      ),
    );
  }
}
