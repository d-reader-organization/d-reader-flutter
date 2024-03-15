import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/sign_up_data_notifier.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/sign_up_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/textfields/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpStep1 extends ConsumerStatefulWidget {
  final Function() onSuccess;
  const SignUpStep1({
    super.key,
    required this.onSuccess,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpStep1State();
}

class _SignUpStep1State extends ConsumerState<SignUpStep1> {
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

  _handleNext() {
    if (_usernameFormKey.currentState!.validate()) {
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
        SvgPicture.asset(
          '${Config.introAssetsPath}/username.svg',
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
                  onValidate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty.';
                    } else if (value.length < 2 || value.length > 20) {
                      return 'Username must be 3 to 20 characters long.';
                    } else if (!usernameRegex.hasMatch(value)) {
                      return 'Letters, numbers and dashes are allowed.';
                    }
                    return null;
                  },
                ),
                const Text(
                  'Must be 2 to 20 characters long. Letters, numbers and dashes are allowed.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.greyscale200,
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
