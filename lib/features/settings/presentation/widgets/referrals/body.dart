import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/shared/presentations/providers/common/common_text_controller_provider.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/widgets/textfields/text_field.dart';
import 'package:d_reader_flutter/features/settings/presentation/widgets/referrals/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReferralBody extends ConsumerWidget {
  final Widget? child;
  const ReferralBody({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUser = ref.watch(myUserProvider);
    return myUser.when(
      data: (user) {
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
                user.hasBetaAccess ? 'Invite your friends' : 'Claim referral',
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
                  'Enter the username or wallet address of your referrer so they can claim the referral bonus',
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
              const Text(
                'Onboarding people to the platform will make you eligible for rewards in the future',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Your referrals remaining: ${user.referralsRemaining}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text:
                          'https://dreader.app/register?referrer=${user.name}',
                    ),
                  ).then((value) {
                    if (context.mounted) {
                      showSnackBar(
                        context: context,
                        text: "Referral link copied to clipboard",
                      );
                    }
                  });
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
              if (child != null) ...[child!],
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return const SizedBox();
      },
      loading: () {
        return Container(
          margin: const EdgeInsets.only(top: 32),
          child: const Center(
            child: CircularProgressIndicator(
              color: ColorPalette.dReaderYellow100,
            ),
          ),
        );
      },
    );
  }
}
