import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInFadeOut;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _fadeInFadeOut =
        Tween<double>(begin: 0.2, end: 1.5).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        nextScreenReplace(
          context: context,
          path: RoutePath.initial,
          homeSubRoute: false,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: FadeTransition(
            opacity: _fadeInFadeOut,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                SvgPicture.asset(
                  Config.whiteLogoPath,
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorPalette.dReaderYellow100,
                    ),
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  child: Text(
                    'beta version',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorPalette.dReaderYellow100,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
