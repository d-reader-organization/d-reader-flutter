import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_in/sign_in_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/textfields/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                  context.pop();
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
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 32,
              ),
              child: Column(
                children: [
                  Text(
                    'Welcome back!',
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Browse the store, start collecting, trading and reading the comics!',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
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
                    autoFillHints: const [
                      AutofillHints.email,
                      AutofillHints.username,
                    ],
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
                    hintText: 'Enter your password',
                    autoFillHints: const [
                      AutofillHints.password,
                    ],
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
                  GestureDetector(
                    onTap: () {
                      nextScreenPush(
                        context: context,
                        path: RoutePath.requestRessetPassword,
                        homeSubRoute: false,
                      );
                    },
                    child: Text(
                      'Forgot password?',
                      textAlign: TextAlign.right,
                      style: textTheme.bodySmall?.copyWith(
                        color: ColorPalette.dReaderYellow100,
                      ),
                    ),
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
                    onPressed: () async {
                      if (_signInFormKey.currentState!.validate()) {
                        await ref
                            .read(signInControllerProvider.notifier)
                            .signIn(
                              nameOrEmail: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              onSuccess: () {
                                nextScreenCloseOthers(
                                  context: context,
                                  path: RoutePath.home,
                                );
                              },
                              onFail: (String message) {
                                showSnackBar(
                                  context: context,
                                  text: message,
                                  backgroundColor: ColorPalette.dReaderRed,
                                );
                              },
                            );
                      }
                    },
                    child: Text(
                      'Login',
                      style: textTheme.titleSmall?.copyWith(
                        color: Colors.black,
                        letterSpacing: .2,
                      ),
                    ),
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
