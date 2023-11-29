import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/auth/auth_provider.dart';
import 'package:d_reader_flutter/core/providers/auth/input_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
import 'package:d_reader_flutter/ui/widgets/d_reader_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

  _handleLogin() async {
    final globalNotifier = ref.read(globalStateProvider.notifier);
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    final response = await ref.read(
      signInProvider(
        nameOrEmail: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ).future,
    );

    if (context.mounted) {
      if (response is String) {
        globalNotifier.update(
          (state) => state.copyWith(
            isLoading: false,
          ),
        );
        return showSnackBar(
          context: context,
          text: response,
          backgroundColor: ColorPalette.dReaderRed,
          milisecondsDuration: 1500,
        );
      }
      final user = await ref.read(myUserProvider.future);
      globalNotifier.update(
        (state) => state.copyWith(
          isLoading: false,
        ),
      );
      ref.read(environmentProvider.notifier).updateEnvironmentState(
            EnvironmentStateUpdateInput(
              user: user,
            ),
          );

      if (context.mounted) {
        nextScreenCloseOthers(context, const DReaderScaffold());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
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
                    labelText: 'Email / Username',
                    hintText: 'Enter you email or username',
                    onValidate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field cannot be empty.';
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
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: const Text(
                  //     'Forgot password?',
                  //     textAlign: TextAlign.right,
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w500,
                  //       color: ColorPalette.dReaderYellow100,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 48,
                  ),
                  RoundedButton(
                    text: 'Login',
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
                      if (_signInFormKey.currentState!.validate()) {
                        await _handleLogin();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
