import 'package:d_reader_flutter/core/providers/common_text_controller_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/intro/selected_button_provider.dart';
import 'package:d_reader_flutter/core/providers/referrals/referral_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/button_with_icon.dart';
import 'package:d_reader_flutter/ui/widgets/settings/bottom_buttons.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReferralsView extends ConsumerWidget {
  const ReferralsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsScaffold(
      appBarTitle: 'Referrals',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 8,
            ),
            SvgPicture.asset('assets/icons/alpha_bunny.svg'),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'Join the alpha',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const Text(
              'Type in the username or the wallet address from your referrer to claim alpha access',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ButtonWithIcon(
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
                ref.read(commonTextValue.notifier).state = '';
                ref.read(commonTextEditingController).clear();
                ref.read(selectedButtonProvider.notifier).state = 'saga';
              },
            ),
            const SizedBox(
              height: 8,
            ),
            ButtonWithIcon(
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
                ref.read(selectedButtonProvider.notifier).state = 'referral';
              },
            ),
            const SizedBox(
              height: 8,
            ),
            ref.watch(selectedButtonProvider) == 'referral'
                ? CustomTextField(
                    hintText: 'Address or Wallet name',
                    controller: ref.read(commonTextEditingController),
                    onChange: (String value) {
                      ref.read(commonTextValue.notifier).state = value;
                    },
                  )
                : const SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final String referrer = ref.watch(commonTextValue);
          return referrer.isNotEmpty ||
                  ref.watch(selectedButtonProvider) == 'saga'
              ? SettingsButtonsBottom(
                  isLoading: ref.watch(globalStateProvider).isLoading,
                  onCancel: () {
                    ref.read(commonTextEditingController).clear();
                    ref.read(commonTextValue.notifier).state = '';
                  },
                  onSave: () async {
                    final notifier = ref.read(globalStateProvider.notifier);
                    notifier.update(
                      (state) => state.copyWith(
                        isLoading: true,
                      ),
                    );
                    final result = await ref.read(
                      updateReferrer(referrer.isEmpty ? 'saga' : referrer)
                          .future,
                    );

                    notifier.update(
                      (state) => state.copyWith(
                        isLoading: false,
                      ),
                    );

                    if (context.mounted) {
                      if (result == 'OK') {
                        ref.read(commonTextEditingController).clear();
                        ref.read(commonTextValue.notifier).state = '';
                        ref.invalidate(myWalletProvider);
                        ref.invalidate(selectedButtonProvider);
                        showSnackBar(
                          context: context,
                          text: 'Referrer has been redeemed.',
                          backgroundColor: ColorPalette.dReaderGreen,
                        );
                        return Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            Navigator.pop(context);
                          },
                        );
                      }
                      showSnackBar(
                        context: context,
                        text: result,
                        backgroundColor: ColorPalette.dReaderRed,
                        duration: 1000,
                      );
                    }
                  },
                )
              : const SizedBox();
        },
      ),
    );
  }
}
