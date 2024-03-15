import 'package:d_reader_flutter/features/authentication/presentation/providers/auth_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/textfields/text_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestResetPasswordView extends StatefulWidget {
  const RequestResetPasswordView({super.key});

  @override
  State<RequestResetPasswordView> createState() =>
      _RequestResetPasswordViewState();
}

class _RequestResetPasswordViewState extends State<RequestResetPasswordView> {
  final GlobalKey<FormState> _resetPasswordFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.appBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Forgot password?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const Text(
              'No worries, enter you email and we\'ll send you reset instructions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: ColorPalette.greyscale100,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Form(
              key: _resetPasswordFormKey,
              child: CustomTextField(
                labelText: 'Email',
                hintText: 'Enter you email',
                controller: _emailController,
                onValidate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field cannot be empty.';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Invalid email address';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Consumer(
              builder: (context, ref, child) {
                return CustomTextButton(
                  padding: const EdgeInsets.all(0),
                  isLoading: ref.watch(globalNotifierProvider).isLoading,
                  size: const Size(
                    double.infinity,
                    50,
                  ),
                  onPressed: () async {
                    if (_resetPasswordFormKey.currentState!.validate()) {
                      await ref
                          .read(authControllerProvider.notifier)
                          .handleRequestResetPassword(
                            email: _emailController.value.text.trim(),
                            onSuccess: () {
                              showSnackBar(
                                context: context,
                                text: 'Reset password mail has been sent.',
                                backgroundColor: ColorPalette.dReaderGreen,
                              );
                            },
                            onException: (cause) {
                              showSnackBar(
                                context: context,
                                text: cause,
                                backgroundColor: ColorPalette.dReaderRed,
                              );
                            },
                          );
                    }
                  },
                  child: Text(
                    'Reset Password',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.black,
                          letterSpacing: .2,
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
