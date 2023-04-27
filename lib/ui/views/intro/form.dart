import 'package:d_reader_flutter/core/providers/referral_provider.dart';
import 'package:d_reader_flutter/core/providers/validate_wallet_name.dart';
import 'package:d_reader_flutter/core/providers/wallet_name_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/settings/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IntroForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  const IntroForm({
    super.key,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SettingsTextField(
            labelText: 'Account name',
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onValidate: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter Wallet Name.";
              }
              final result = ref.read(validateWalletNameProvider(value));
              return result.value != null && result.value!
                  ? null
                  : 'Wallet Name not allowed.';
            },
            onChange: (value) async {
              ref.read(walletNameProvider.notifier).state = value;
              ref.read(validateWalletNameProvider(value).future);
            },
          ),
          ref.watch(hasReferralProvider)
              ? SettingsTextField(
                  labelText: 'Referrer name/address',
                  hintText: 'Referrer name',
                  onChange: (String value) {
                    ref.read(referrerNameProvider.notifier).state = value;
                  },
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(hasReferralProvider.notifier).state = true;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ticket.svg',
                            colorFilter: const ColorFilter.mode(
                              ColorPalette.dReaderYellow100,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'Have referral code?',
                            style: TextStyle(
                              color: ColorPalette.dReaderYellow100,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
