import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpStep2Verification extends StatelessWidget {
  const SignUpStep2Verification({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/icons/envelope.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Check your mail',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Follow the instructions within to confirm and activate your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.greyscale100,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextButton(
                  onPressed: () {
                    // open email app
                  },
                  borderRadius: BorderRadius.circular(8),
                  size: const Size(120, 50),
                  child: const Text(
                    'Open email app',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(
            flex: 3,
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const Text(
                  "Didn't get the email?\nCheck your spam folder before resending",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.greyscale200,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    // resend
                  },
                  child: const Text(
                    'Resend email confirmation link',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorPalette.dReaderYellow100,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
