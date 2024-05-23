import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_in/sign_in_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/shared/widgets/icons/secure_password_icon.dart';
import 'package:d_reader_flutter/shared/widgets/textfields/text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

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
            const VectorGraphic(
              loader: AssetBytesLoader(Config.whiteLogoSymbol),
              height: 64,
              width: 64,
              colorFilter: ColorFilter.mode(
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
                    suffix: const SecurePasswordIcon(),
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
