import 'package:d_reader_flutter/core/models/exceptions.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChangeEmailView extends ConsumerStatefulWidget {
  const ChangeEmailView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangeEmailViewState();
}

class _ChangeEmailViewState extends ConsumerState<ChangeEmailView> {
  final TextEditingController _newEmailController = TextEditingController();
  final GlobalKey<FormState> _newEmailFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _newEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      appBarTitle: '',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Enter your new email and we will send you verification email.',
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
            key: _newEmailFormKey,
            child: CustomTextField(
              labelText: 'Email',
              hintText: 'Enter you email',
              controller: _newEmailController,
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
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomTextButton(
          size: const Size(double.infinity, 50),
          isLoading: ref.watch(globalStateProvider).isLoading,
          onPressed: () async {
            if (!_newEmailFormKey.currentState!.validate()) {
              return;
            }
            final globalNotifier = ref.read(globalStateProvider.notifier);
            globalNotifier.update(
              (state) => state.copyWith(isLoading: true),
            );
            try {
              await ref
                  .read(userRepositoryProvider)
                  .requestChangeEmail(_newEmailController.text.trim());
              globalNotifier.update(
                (state) => state.copyWith(
                  isLoading: false,
                ),
              );
              if (context.mounted) {
                showSnackBar(
                  context: context,
                  text:
                      'Verification mail sent to your new email address. Please check spam',
                  backgroundColor: ColorPalette.dReaderGreen,
                );
              }
            } catch (exception) {
              globalNotifier.update(
                (state) => state.copyWith(
                  isLoading: false,
                ),
              );
              if (exception is BadRequestException && context.mounted) {
                showSnackBar(
                  context: context,
                  text: exception.cause,
                  backgroundColor: ColorPalette.dReaderRed,
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: const Text('Submit'),
        ),
      ),
    );
  }
}
