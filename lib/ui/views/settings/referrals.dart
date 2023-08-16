import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/common_text_controller_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
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
              height: 8,
            ),
            CustomTextField(
              hintText: 'Username or Wallet address',
              controller: ref.read(commonTextEditingController),
              onChange: (String value) {
                ref.read(commonTextValue.notifier).state = value;
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
                    final currentUser = ref.read(environmentProvider).user;
                    dynamic updateResult;
                    if (currentUser != null) {
                      updateResult =
                          await ref.read(userRepositoryProvider).updateUser(
                                UpdateUserPayload(
                                  id: currentUser.id,
                                  referrer: referrer,
                                ),
                              );
                    }

                    notifier.update(
                      (state) => state.copyWith(
                        isLoading: false,
                      ),
                    );

                    if (context.mounted) {
                      ref.read(commonTextEditingController).clear();
                      ref.read(commonTextValue.notifier).state = '';
                      ref.invalidate(myUserProvider);

                      showSnackBar(
                        context: context,
                        text: updateResult is String
                            ? updateResult
                            : 'Referrer has been redeemed.',
                        backgroundColor: updateResult is String
                            ? ColorPalette.dReaderRed
                            : ColorPalette.dReaderGreen,
                      );
                      return Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          Navigator.pop(context);
                        },
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
