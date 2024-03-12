import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/sign_up_data_notifier.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/sign_up_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/textfields/text_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpStep2 extends ConsumerStatefulWidget {
  final Function() onSuccess;
  final Function(String text) onFail;
  const SignUpStep2({
    super.key,
    required this.onSuccess,
    required this.onFail,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpStep1State();
}

class _SignUpStep1State extends ConsumerState<SignUpStep2> {
  final GlobalKey<FormState> _step2FormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    final signupData = ref.read(signUpDataNotifierProvider);
    _emailController.text = signupData.email;
    _passwordController.text = signupData.password;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SvgPicture.asset(
          '${Config.introAssetsPath}/email_pass.svg',
          fit: BoxFit.fitWidth,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32,
          ),
          child: Text(
            'Secure your account',
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
            key: _step2FormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  labelText: 'Email',
                  hintText: 'Enter you email',
                  onValidate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty.';
                    } else if (!EmailValidator.validate(value)) {
                      return 'Invalid email.';
                    }
                    return null;
                  },
                  controller: _emailController,
                ),
                CustomTextField(
                  labelText: 'Password',
                  hintText: 'Set your password',
                  controller: _passwordController,
                  obscureText: ref.watch(obscureTextProvider),
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
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  '8 characters minimum. Must contain at least 1 lowercase, 1 uppercase character and 1 number.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.greyscale200,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                RichText(
                  text: const TextSpan(
                    text: 'By clicking on confirm you accept our ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorPalette.greyscale200,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorPalette.dReaderYellow100,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                CustomTextButton(
                  padding: const EdgeInsets.all(0),
                  isLoading: ref.watch(globalNotifierProvider).isLoading,
                  size: const Size(
                    double.infinity,
                    50,
                  ),
                  onPressed: () async {
                    if (_step2FormKey.currentState!.validate()) {
                      ref
                          .read(signUpDataNotifierProvider.notifier)
                          .updateEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                      await ref.read(signUpNotifierProvider.notifier).signUp(
                            data: ref.read(signUpDataNotifierProvider),
                            onSuccess: widget.onSuccess,
                            onFail: widget.onFail,
                          );
                    }
                  },
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
