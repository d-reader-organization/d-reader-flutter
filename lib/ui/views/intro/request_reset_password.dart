import 'package:d_reader_flutter/core/models/exceptions.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
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
                return RoundedButton(
                  text: 'Reset Password',
                  padding: 0,
                  isLoading: ref.watch(globalStateProvider).isLoading,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    letterSpacing: .2,
                  ),
                  size: const Size(
                    double.infinity,
                    50,
                  ),
                  onPressed: () async {
                    if (_resetPasswordFormKey.currentState!.validate()) {
                      final globalNotifier =
                          ref.read(globalStateProvider.notifier);
                      globalNotifier.update(
                        (state) => state.copyWith(
                          isLoading: true,
                        ),
                      );
                      try {
                        await ref
                            .read(userRepositoryProvider)
                            .requestPasswordReset(
                              _emailController.value.text.trim(),
                            );
                        globalNotifier.update(
                          (state) => state.copyWith(
                            isLoading: false,
                          ),
                        );
                        if (context.mounted) {
                          showSnackBar(
                            context: context,
                            text: 'Reset password mail has been sent.',
                            backgroundColor: ColorPalette.dReaderGreen,
                          );
                        }
                      } catch (exception) {
                        globalNotifier.update(
                          (state) => state.copyWith(
                            isLoading: false,
                          ),
                        );
                        if (exception is BadRequestException &&
                            context.mounted) {
                          showSnackBar(
                            context: context,
                            text: exception.cause,
                            backgroundColor: ColorPalette.dReaderRed,
                          );
                        }
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
