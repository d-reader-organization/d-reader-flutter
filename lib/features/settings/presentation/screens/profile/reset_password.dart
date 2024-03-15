import 'package:d_reader_flutter/features/settings/presentation/providers/profile_controller.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResetPasswordView extends StatelessWidget {
  final String id, email;
  const ResetPasswordView({
    super.key,
    required this.id,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Reset password',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          RichText(
            text: TextSpan(
                text:
                    'We’ll send an email with reset password instructions to ',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.greyscale100,
                ),
                children: [
                  TextSpan(
                    text: email,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )
                ]),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer(
          builder: (context, ref, child) {
            return CustomTextButton(
              borderRadius: BorderRadius.circular(8),
              isLoading: ref.watch(globalNotifierProvider).isLoading,
              padding: EdgeInsets.zero,
              onPressed: () {
                ref
                    .read(profileControllerProvider.notifier)
                    .sendResetPasswordInstructions(
                      email: email,
                      callback: (String result) {
                        showSnackBar(
                          context: context,
                          text: result,
                          backgroundColor: ColorPalette.dReaderGreen,
                        );
                      },
                    );
              },
              size: const Size(
                double.infinity,
                50,
              ),
              child: const Text(
                'Send instructions',
              ),
            );
          },
        ),
      ),
    );
  }
}
