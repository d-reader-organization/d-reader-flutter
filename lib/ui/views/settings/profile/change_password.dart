import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/core/providers/auth/input_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/views/settings/profile/reset_password.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChangePasswordView extends ConsumerStatefulWidget {
  final int userId;
  final String email;
  const ChangePasswordView({
    super.key,
    required this.userId,
    required this.email,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordViewState();
}

class _ChangePasswordViewState extends ConsumerState<ChangePasswordView> {
  final GlobalKey<FormState> _changePasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  _handlePasswordChange() async {
    final globalNotifier = ref.read(globalStateProvider.notifier);

    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    final result = await ref.read(userRepositoryProvider).updatePassword(
          userId: widget.userId,
          oldPassword: _oldPasswordController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
        );
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );
    if (context.mounted) {
      final isFailure = result is String && result.isNotEmpty;
      showSnackBar(
        context: context,
        text: isFailure ? result : 'Password has been changed.',
        backgroundColor:
            isFailure ? ColorPalette.dReaderRed : ColorPalette.dReaderGreen,
        milisecondsDuration: 1200,
      );
      if (!isFailure) {
        Future.delayed(
          const Duration(seconds: 1),
          () {
            Navigator.pop(context);
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      appBarTitle: '',
      bottomNavigationBar: AnimatedOpacity(
        opacity: ref.watch(oldPasswordProvider).trim().isNotEmpty &&
                ref.watch(newPasswordProvider).trim().isNotEmpty
            ? 1.0
            : 0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextButton(
            size: const Size(double.infinity, 50),
            isLoading: ref.watch(globalStateProvider).isLoading,
            onPressed: () async {
              if (_changePasswordFormKey.currentState!.validate()) {
                await _handlePasswordChange();
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: const Text('Submit'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Change your password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Your new password must be different from previously used passwords.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ColorPalette.greyscale100,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Form(
              key: _changePasswordFormKey,
              child: Column(
                children: [
                  CustomTextField(
                    labelText: 'Current password',
                    hintText: 'Set your password',
                    controller: _oldPasswordController,
                    obscureText: ref.watch(obscureTextProvider),
                    onChange: (value) {
                      ref
                          .read(oldPasswordProvider.notifier)
                          .update((state) => value);
                    },
                    onValidate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field cannot be empty.';
                      }
                      return null;
                    },
                    suffix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(obscureTextProvider.notifier)
                              .update((state) => !state);
                        },
                        child: Icon(
                          ref.watch(obscureTextProvider)
                              ? FontAwesomeIcons.solidEye
                              : FontAwesomeIcons.solidEyeSlash,
                          color: ColorPalette.boxBackground400,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  CustomTextField(
                    labelText: 'New password',
                    hintText: 'Set your password',
                    controller: _newPasswordController,
                    obscureText: ref.watch(additionalObscureTextProvider),
                    onChange: (value) {
                      ref
                          .read(newPasswordProvider.notifier)
                          .update((state) => value);
                    },
                    onValidate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field cannot be empty.';
                      } else if (value.length < 8) {
                        return 'Password has to be minimum 8 characters length.';
                      } else if (!passwordRegex.hasMatch(value)) {
                        return 'At least 1 upper, lower case letter and 1 number.';
                      }
                      return null;
                    },
                    suffix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(additionalObscureTextProvider.notifier)
                              .update((state) => !state);
                        },
                        child: Icon(
                          ref.watch(obscureTextProvider)
                              ? FontAwesomeIcons.solidEye
                              : FontAwesomeIcons.solidEyeSlash,
                          color: ColorPalette.boxBackground400,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                '8 characters minimum. Must contain at least 1 lowercase, 1 uppercase character and 1 number.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.greyscale200,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                nextScreenPush(
                  context,
                  ResetPasswordView(
                    id: '${widget.userId}',
                    email: widget.email,
                  ),
                );
              },
              child: const Text(
                'Forgot password?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.dReaderYellow100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}