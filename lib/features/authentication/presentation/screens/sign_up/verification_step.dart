import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/sign_up_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class SignUpVerificationStep extends StatelessWidget {
  final Function() handleNext;
  const SignUpVerificationStep({
    super.key,
    required this.handleNext,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                const VectorGraphic(
                  loader: AssetBytesLoader(
                    'assets/icons/envelope.svg',
                  ),
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
                  'Follow the simple instructions within the email to verify and become eligible for rewards. It might take up to 5 minutes to receive the mail',
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
                  padding: const EdgeInsets.all(0),
                  onPressed: handleNext,
                  child: Text(
                    'Next',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.black,
                          letterSpacing: .2,
                        ),
                  ),
                ),
              ],
            ),
            Column(
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
                Consumer(
                  builder: (context, ref, child) {
                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(signUpNotifierProvider.notifier)
                            .handleResendVerification(
                          callback: () {
                            showSnackBar(
                              context: context,
                              text: 'Verification email has been resent.',
                              backgroundColor: ColorPalette.dReaderGreen,
                            );
                          },
                        );
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
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
