import 'package:d_reader_flutter/core/providers/common_text_controller_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
import 'package:d_reader_flutter/ui/widgets/referrals/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ReferralBody extends ConsumerWidget {
  final bool onlyInput;
  const ReferralBody({
    super.key,
    this.onlyInput = false,
  });

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
        return SingleChildScrollView(
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
              if (!user.hasBetaAccess) ...[
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
                      await handleSave(context, ref, value);
                    }
                  },
                  onChange: (String value) {
                    ref.read(commonTextValue.notifier).state = value;
                  },
                ),
              ],
              if (!onlyInput) ...[
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.copy,
                          color: ColorPalette.dReaderYellow100,
                          size: 16,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Copy my referral link',
                          style: TextStyle(
                            fontSize: 16,
                            color: ColorPalette.dReaderYellow100,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
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
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        Sentry.captureException(error, stackTrace: stackTrace);
        return const SizedBox();
      },
      loading: () {
        return const SizedBox();
      },
    );
  }
}
