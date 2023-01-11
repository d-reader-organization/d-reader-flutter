import 'package:d_reader_flutter/config/config.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Config.logoTextPath),
          const SizedBox(
            height: 24,
          ),
          Text(
            'Connected',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Lottie.asset(
            Config.successAuthAsset,
            alignment: Alignment.center,
            fit: BoxFit.cover,
            height: 200,
            width: 200,
            repeat: false,
          ),
        ],
      ),
    );
  }
}
