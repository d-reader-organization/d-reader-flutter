import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/common_text_controller_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/settings/bottom_buttons.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ReferralsView extends ConsumerWidget {
  const ReferralsView({super.key});

  _handleSave(BuildContext context, WidgetRef ref, String referrer) async {
    final notifier = ref.read(globalStateProvider.notifier);
    notifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    final currentUser = ref.read(environmentProvider).user;
    dynamic updateResult;
    if (currentUser != null) {
      updateResult = await ref.read(userRepositoryProvider).updateUser(
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
    ref.invalidate(myUserProvider);
    final result = await ref.read(myUserProvider.future);
    ref.read(environmentProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            user: result,
          ),
        );

    if (context.mounted) {
      ref.read(commonTextEditingController).clear();
      ref.read(commonTextValue.notifier).state = '';

      showSnackBar(
        context: context,
        text: updateResult is String
            ? updateResult
            : 'Referrer has been redeemed.',
        backgroundColor: updateResult is String
            ? ColorPalette.dReaderRed
            : ColorPalette.dReaderGreen,
      );
      // return Future.delayed(
      //   const Duration(seconds: 1),
      //   () {
      //     Navigator.pop(context);
      //   },
      // );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUser = ref.watch(myUserProvider);
    return myUser.when(
      data: (user) {
        if (user == null) {
          return const Center(
            child: Text(
              'Failed to get user',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          );
        }
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
                Text(
                  user.hasBetaAccess ? 'Invite your friends' : 'Join the beta',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  'Type in the username, email, or wallet address from your referrer to unlock all the features',
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
                  onFieldSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      await _handleSave(context, ref, value);
                    }
                  },
                  onChange: (String value) {
                    ref.read(commonTextValue.notifier).state = value;
                  },
                ),
                if (user.referralsRemaining > 0) ...[
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text:
                              'https://dreader.app/register?referrer=${user.name}',
                        ),
                      ).then(
                        (value) => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: ColorPalette.dReaderGreen,
                            content: Text(
                              "Referral link copied to clipboard",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Copy my referral link',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorPalette.dReaderYellow100,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
                Text(
                  'Referrals remaining: ${user.referralsRemaining}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
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
                        await _handleSave(context, ref, referrer);
                      },
                    )
                  : const SizedBox();
            },
          ),
        );
      },
      error: (error, stackTrace) {
        Sentry.captureException(error, stackTrace: stackTrace);
        return const Text('');
      },
      loading: () {
        return const SizedBox();
      },
    );
  }
}
