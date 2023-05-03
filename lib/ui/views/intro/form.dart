import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/referrals/referral_provider.dart';
import 'package:d_reader_flutter/core/providers/validate_wallet_name.dart';
import 'package:d_reader_flutter/core/providers/wallet_name_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
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
          CustomTextField(
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
          ref.watch(globalStateProvider).isLoading
              ? const Center(
                  child: SizedBox(
                    height: 48,
                    width: 48,
                    child: CircularProgressIndicator(
                      color: ColorPalette.dReaderBlue,
                    ),
                  ),
                )
              : ref.watch(globalStateProvider).isReferred
                  ? const SizedBox(
                      height: 48,
                      width: 48,
                      child: Icon(
                        Icons.check_circle_outline_outlined,
                        color: ColorPalette.dReaderGreen,
                        size: 48,
                      ),
                    )
                  : Column(
                      children: [
                        ref.watch(hasReferralProvider)
                            ? CustomTextField(
                                labelText: 'Referrer name/address',
                                hintText: 'Referrer name',
                                onChange: (String value) {
                                  ref
                                      .read(referrerNameProvider.notifier)
                                      .state = value;
                                },
                              )
                            : Column(
                                children: [
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(hasReferralProvider.notifier)
                                          .state = true;
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            color:
                                                ColorPalette.dReaderYellow100,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () async {
                                final notifier =
                                    ref.read(globalStateProvider.notifier);
                                notifier.update(
                                  (state) => state.copyWith(
                                    isLoading: true,
                                  ),
                                );
                                final result = await ref.read(
                                  updateWalletProvider(
                                    UpdateWalletPayload(
                                      address: 'address',
                                      referrer: 'Saga',
                                    ),
                                  ).future,
                                );
                                if (result != null && context.mounted) {
                                  notifier.update(
                                    (state) => state.copyWith(
                                      isLoading: false,
                                      isReferred: true,
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'I am Saga user',
                                style: TextStyle(
                                  color: ColorPalette.dReaderYellow100,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
        ],
      ),
    );
  }
}
