import 'dart:async' show Timer;

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/intro/selected_button_provider.dart';
import 'package:d_reader_flutter/core/providers/referrals/referral_provider.dart';
import 'package:d_reader_flutter/core/providers/validate_wallet_name.dart';
import 'package:d_reader_flutter/core/providers/wallet_name_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/username_validator.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/button_with_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IntroForm extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  const IntroForm({
    super.key,
    required this.formKey,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IntroFormState();
}

class _IntroFormState extends ConsumerState<IntroForm> {
  Timer? _debouncer;

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          key: widget.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                labelText: 'Username',
                hintText: 'eg. BunBun',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onValidate: (value) {
                  return validateUsername(value: value, ref: ref);
                },
                onChange: (value) {
                  if (_debouncer?.isActive ?? false) {
                    _debouncer?.cancel();
                  }
                  _debouncer =
                      Timer(const Duration(milliseconds: 200), () async {
                    final validatorNotifier =
                        ref.read(isValidWalletNameValue.notifier);
                    ref.read(walletNameProvider.notifier).state = value;
                    if (value.isEmpty) {
                      validatorNotifier.state = false;
                      return;
                    }
                    final result = await ref
                        .read(validateWalletNameProvider(value).future);
                    validatorNotifier.state = result;
                  });
                },
              ),
              const SizedBox(
                height: 8,
              ),
              ref.read(environmentProvider).solanaCluster ==
                      SolanaCluster.devnet.value
                  ? const SizedBox()
                  : Row(
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
                                ref
                                    .read(selectedButtonProvider.notifier)
                                    .state = '';
                              } else {
                                ref
                                    .read(selectedButtonProvider.notifier)
                                    .state = 'saga';
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
                              if (ref.read(selectedButtonProvider) ==
                                  'referral') {
                                ref
                                    .read(selectedButtonProvider.notifier)
                                    .state = '';
                              } else {
                                ref
                                    .read(selectedButtonProvider.notifier)
                                    .state = 'referral';
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
