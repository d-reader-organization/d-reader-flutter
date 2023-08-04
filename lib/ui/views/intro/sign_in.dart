import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/core/providers/auth/auth_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final obscureTextProvider = StateProvider<bool>((ref) {
  return true;
});

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
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
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(
            height: 32,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          SvgPicture.asset(
            Config.whiteLogoSymbol,
            height: 64,
            width: 64,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(),
          const SizedBox(
            height: 32,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 32,
            ),
            child: Column(
              children: [
                Text(
                  'Welcome back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Browse the store, start collecting, trading and reading the comics!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Form(
            key: _signInFormKey,
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
                      return 'Password must contain at least 1 upper and lower case letter. Needs to have at least 1 number or special character.';
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
                const Text(
                  'Forgot password?',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.dReaderYellow100,
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                RoundedButton(
                  text: 'Login',
                  padding: 0,
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
                    if (_signInFormKey.currentState!.validate()) {
                      final authRepo = ref.read(authRepositoryProvider);
                      final response = await authRepo.signIn(
                        nameOrEmail: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                      if (response is String && context.mounted) {
                        return showSnackBar(
                          context: context,
                          text: response,
                          backgroundColor: ColorPalette.dReaderRed,
                          duration: 1500,
                        );
                      }
                      // TODO Go on home screen
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
