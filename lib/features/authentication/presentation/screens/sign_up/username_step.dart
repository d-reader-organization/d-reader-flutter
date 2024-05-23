import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/sign_up_data_notifier.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/sign_up_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/utils/url_utils.dart';
import 'package:d_reader_flutter/shared/utils/validation.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/shared/widgets/textfields/text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class SignUpUsernameStep extends ConsumerStatefulWidget {
  final Function() onSuccess;
  final void Function()? overrideNext;
  const SignUpUsernameStep({
    super.key,
    required this.onSuccess,
    this.overrideNext,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SignUpUsernameStepState();
}

class _SignUpUsernameStepState extends ConsumerState<SignUpUsernameStep> {
  final GlobalKey<FormState> _usernameFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    _usernameController.text = ref.read(signUpDataNotifierProvider).username;
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_usernameFormKey.currentState!.validate()) {
      if (widget.overrideNext != null) {
        ref.read(signUpDataNotifierProvider.notifier).updateUsername(
              _usernameController.text.trim(),
            );
        return widget.overrideNext!();
      }
      ref.read(signUpNotifierProvider.notifier).handleSignUpStep1(
            username: _usernameController.text.trim(),
            onSuccess: widget.onSuccess,
            onFail: (String message) {
              showSnackBar(
                context: context,
                text: message,
                backgroundColor: ColorPalette.dReaderRed,
              );
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const VectorGraphic(
          loader: AssetBytesLoader(
            '${Config.introAssetsPath}/username.svg',
          ),
          fit: BoxFit.fitWidth,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32,
          ),
          child: Text(
            'Set your username',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _usernameFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  labelText: 'Username',
                  hintText: 'e.g Bun-Bun',
                  controller: _usernameController,
                  onValidate: usernameValidation,
                ),
                const Text(
                  usernameCriteriaText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.greyscale200,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/double_tick.svg',
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text:
                              'By creating an account I confirm I read and agree to the ',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: ColorPalette.greyscale200),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Terms of Service ',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  openUrl(Config.privacyPolicyUrl,
                                      LaunchMode.inAppWebView);
                                },
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: ColorPalette.dReaderYellow100),
                            ),
                            TextSpan(
                              text: '& ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: ColorPalette.greyscale200),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  openUrl(Config.privacyPolicyUrl,
                                      LaunchMode.inAppWebView);
                                },
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: ColorPalette.dReaderYellow100),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 48,
                ),
                CustomTextButton(
                  isLoading: ref.watch(globalNotifierProvider).isLoading,
                  padding: const EdgeInsets.all(0),
                  size: const Size(
                    double.infinity,
                    50,
                  ),
                  onPressed: _handleNext,
                  child: Text(
                    'Next',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.black,
                          letterSpacing: .2,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
