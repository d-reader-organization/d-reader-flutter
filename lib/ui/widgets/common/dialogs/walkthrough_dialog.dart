import 'dart:ui' show ImageFilter;

import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalkthroughDialog extends StatelessWidget {
  final Function() onSubmit;
  final String buttonText, title, subtitle;
  const WalkthroughDialog({
    super.key,
    required this.onSubmit,
    required this.title,
    required this.subtitle,
    this.buttonText = 'Next',
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
          height: 100,
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
                    height: 60,
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorPalette.greyscale50,
          ),
        ),
        CustomTextButton(
          onPressed: onSubmit,
          borderRadius: BorderRadius.circular(8),
          child: Text(
            buttonText,
            style: const TextStyle(
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
