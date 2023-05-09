import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/intro/selected_button_provider.dart';
import 'package:d_reader_flutter/core/providers/referrals/referral_provider.dart';
import 'package:d_reader_flutter/core/providers/validate_wallet_name.dart';
import 'package:d_reader_flutter/core/providers/wallet_name_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/button_with_icon.dart';
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
    final provider = ref.watch(myWalletProvider);
    return provider.maybeWhen(
      orElse: () {
        return const Text('Failed to load wallet');
      },
      loading: () {
        return const SizedBox();
      },
      data: (wallet) {
        if (wallet == null) {
          return const Text('No wallet');
        }
        return Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                labelText: 'Account name',
                hintText: 'eg. BunBun',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onValidate: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter account name.";
                  } else if (value.length > 24) {
                    return "Must be 24 characters.";
                  }
                  final result = ref.watch(isValidWalletNameValue);
                  return result ? null : '$value already taken.';
                },
                onChange: (value) async {
                  final validatorNotifier =
                      ref.read(isValidWalletNameValue.notifier);
                  ref.read(walletNameProvider.notifier).state = value;
                  if (value.isEmpty) {
                    return validatorNotifier.state = false;
                  }
                  final result =
                      await ref.read(validateWalletNameProvider(value).future);
                  validatorNotifier.state = result;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ButtonWithIcon(
                      name: 'saga',
                      label: const Text(
                        'Have Saga',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        'assets/icons/category.svg',
                        colorFilter: ColorFilter.mode(
                          ref.watch(selectedButtonProvider) == 'saga'
                              ? Colors.black
                              : Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      selectedColor: ColorPalette.dReaderYellow100,
                      onPressed: () {
                        if (ref.read(selectedButtonProvider) == 'saga') {
                          ref.read(selectedButtonProvider.notifier).state = '';
                        } else {
                          ref.read(selectedButtonProvider.notifier).state =
                              'saga';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ButtonWithIcon(
                      name: 'referral',
                      label: const Text(
                        'Referral code',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        'assets/icons/ticket.svg',
                        colorFilter: ColorFilter.mode(
                          ref.watch(selectedButtonProvider) == 'referral'
                              ? Colors.black
                              : Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      selectedColor: ColorPalette.dReaderYellow100,
                      onPressed: () {
                        if (ref.read(selectedButtonProvider) == 'referral') {
                          ref.read(selectedButtonProvider.notifier).state = '';
                        } else {
                          ref.read(selectedButtonProvider.notifier).state =
                              'referral';
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
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
                            ref.watch(selectedButtonProvider) == 'referral'
                                ? CustomTextField(
                                    hintText: 'Type in referral code',
                                    onChange: (String value) {
                                      ref
                                          .read(referrerNameProvider.notifier)
                                          .state = value;
                                    },
                                  )
                                : const SizedBox(),
                          ],
                        ),
            ],
          ),
        );
      },
    );
  }
}
