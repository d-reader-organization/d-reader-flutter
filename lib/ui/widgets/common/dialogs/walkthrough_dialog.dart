import 'dart:ui' show ImageFilter;

import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalkthroughDialog extends StatelessWidget {
  final Function() onSubmit;
  const WalkthroughDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(
        16,
      ),
      backgroundColor: ColorPalette.boxBackground300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          8,
        ),
      ),
      children: [
        SizedBox(
          height: 140,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 2,
                    sigmaY: 2,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/logo-white.svg',
                    height: 80,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Text(
          'Some text',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const Text(
          'Tap on the comic cover to get a quick preview or read it fully if you already own it.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorPalette.greyscale50,
          ),
        ),
        CustomTextButton(
          onPressed: onSubmit,
          borderRadius: BorderRadius.circular(8),
          child: const Text(
            'Got it',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
