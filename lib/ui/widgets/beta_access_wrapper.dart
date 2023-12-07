import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/launch_external_url.dart';
import 'package:d_reader_flutter/ui/widgets/referrals/body.dart';
import 'package:d_reader_flutter/ui/widgets/referrals/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class BetaAccessWrapper extends ConsumerWidget {
  final Widget child;
  const BetaAccessWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(environmentProvider).user?.hasBetaAccess != null &&
            !ref.watch(environmentProvider).user!.hasBetaAccess
        ? Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const ReferralBody(
                      onlyInput: true,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ColorPalette.greyscale500,
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'How to get code?',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Connect with us on social media to find if any invite codes are available!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ColorPalette.greyscale100,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: BetaButton(
                                  iconPath:
                                      '${Config.settingsAssetsPath}/light/twitter.svg',
                                  labelText: 'Twitter',
                                  onPressed: () {
                                    openUrl(
                                      Config.twitterUrl,
                                      LaunchMode.externalApplication,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: BetaButton(
                                  iconPath:
                                      '${Config.settingsAssetsPath}/light/discord.svg',
                                  labelText: 'Discord',
                                  onPressed: () {
                                    openUrl(
                                      Config.discordUrl,
                                      LaunchMode.externalApplication,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const ReferralBottomNavigation(),
              ],
            ),
          )
        : child;
    // ? ref.watch(myUserProvider).maybeWhen(
    //     data: (data) {
    //       if (data == null || data.role == UserRole.tester.name) {
    //         return const Center(
    //           child: Text(
    //             "You do not have alpha access. Go to 'settings > referrals' to claim it",
    //             textAlign: TextAlign.center,
    //             style: TextStyle(
    //               fontSize: 18,
    //               fontWeight: FontWeight.w600,
    //             ),
    //           ),
    //         );
    //       }
    //       return child;
    //     },
    //     orElse: () {
    //       return const SizedBox();
    //     },
    //   )
    // : child;
  }
}

class BetaButton extends StatelessWidget {
  final String iconPath, labelText;
  final Function() onPressed;
  const BetaButton({
    super.key,
    required this.iconPath,
    required this.labelText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        backgroundColor: ColorPalette.appBackgroundColor,
        minimumSize: const Size(
          double.infinity,
          48,
        ),
        maximumSize: const Size(
          double.infinity,
          48,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
          side: const BorderSide(
            color: ColorPalette.greyscale300,
            width: 1,
          ),
        ),
      ),
      onPressed: onPressed,
      icon: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
      label: Text(
        labelText,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
