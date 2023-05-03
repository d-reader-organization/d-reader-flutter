import 'package:d_reader_flutter/core/providers/common_text_controller_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/referrals/referral_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/settings/bottom_buttons.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReferralsView extends StatelessWidget {
  const ReferralsView({super.key});

  @override
  Widget build(BuildContext context) {
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
            Consumer(
              builder: (context, ref, child) {
                return CustomTextField(
                  hintText: 'Address or Wallet name',
                  controller: ref.read(commonTextEditingController),
                  onChange: (String value) {
                    ref.read(commonTextValue.notifier).state = value;
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final String referrer = ref.watch(commonTextValue);
          return referrer.isNotEmpty
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
                      updateReferrer(referrer).future,
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
                        showSnackBar(
                          context: context,
                          text: 'Referrer has been redeemed.',
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
