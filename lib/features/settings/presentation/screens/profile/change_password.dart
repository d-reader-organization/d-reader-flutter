import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/settings/presentation/providers/profile_controller.dart';
import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/shared/widgets/textfields/text_field.dart';
import 'package:d_reader_flutter/features/settings/presentation/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
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
    await ref.read(profileControllerProvider.notifier).changePassword(
          userId: widget.userId,
          oldPassword: _oldPasswordController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
          callback: (result) {
            final isFailure = result is String && result.isNotEmpty;
            showSnackBar(
              context: context,
              text: isFailure ? result : 'Password has been changed.',
              backgroundColor: isFailure
                  ? ColorPalette.dReaderRed
                  : ColorPalette.dReaderGreen,
            );
            if (!isFailure) {
              Future.delayed(
                const Duration(seconds: 1),
                () {
                  context.pop();
                },
              );
            }
          },
        );
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
            isLoading: ref.watch(globalNotifierProvider).isLoading,
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
                          color: ColorPalette.greyscale300,
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
                          color: ColorPalette.greyscale300,
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
                  context: context,
                  path:
                      '${RoutePath.resetPassword}?userId=${widget.userId}&email=${widget.email}',
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
