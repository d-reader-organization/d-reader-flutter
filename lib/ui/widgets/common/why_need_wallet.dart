import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:flutter/material.dart';

class WhyDoINeedWalletWidget extends StatelessWidget {
  const WhyDoINeedWalletWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: RoutePath.whatIsAWallet,
        );
      },
      child: const Text(
        'Why do I need a wallet?',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ColorPalette.dReaderYellow100,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
