import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const defaultErrorMessage = 'Something broke!';
const defaultAdviceText =
    'Try resetting the app and make sure it\'s running on the latest version';

class CarrotErrorScaffold extends StatelessWidget {
  final String adviceText, errorText;
  const CarrotErrorScaffold({
    super.key,
    this.adviceText = defaultAdviceText,
    this.errorText = defaultErrorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      extendBodyBehindAppBar: true,
      body: CarrotErrorWidget(
        mainErrorText: errorText,
      ),
    );
  }
}

class CarrotErrorWidget extends StatelessWidget {
  final String adviceText, mainErrorText;
  final double height;
  final EdgeInsets? padding;
  final Widget? additionalChild;
  const CarrotErrorWidget({
    super.key,
    this.adviceText = defaultAdviceText,
    this.mainErrorText = defaultErrorMessage,
    this.height = 300,
    this.padding,
    this.additionalChild,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0,
            .69,
          ],
          colors: [
            ColorPalette.dReaderError,
            ColorPalette.appBackgroundColor,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset(
            'assets/icons/carrot_error.svg',
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            mainErrorText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            adviceText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorPalette.greyscale100,
                ),
          ),
          if (additionalChild != null) ...[
            const SizedBox(
              height: 16,
            ),
            additionalChild!
          ]
        ],
      ),
    );
  }
}
