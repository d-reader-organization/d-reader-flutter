import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/profile.dart';
import 'package:d_reader_flutter/ui/views/settings/about.dart';
import 'package:d_reader_flutter/ui/views/settings/change_network.dart';
import 'package:d_reader_flutter/ui/widgets/settings/container.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsRootView extends StatelessWidget {
  const SettingsRootView({super.key});

  final textStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsContainer(
            onPressed: () {
              nextScreenPush(context, const ProfileView());
            },
            leftWidget: Text(
              'Wallet',
              style: textStyle,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SettingsContainer(
            leftWidget: Text(
              'Address Book',
              style: textStyle.copyWith(color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SettingsContainer(
            onPressed: () {
              nextScreenPush(context, const ChangeNetworkView());
            },
            leftWidget: Text(
              'Change Network',
              style: textStyle,
            ),
            rightWidget: Consumer(
              builder: (context, ref, child) {
                final clusterText =
                    ref.watch(environmentProvider).solanaCluster ==
                            SolanaCluster.mainnet.value
                        ? 'Mainnet'
                        : 'Devnet';
                return Row(
                  children: [
                    Text(
                      clusterText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SettingsContainer(
            leftWidget: Text(
              'Redeem referral code',
              style: textStyle.copyWith(color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SettingsContainer(
            leftWidget: Text(
              'Notifications',
              style: textStyle.copyWith(color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SettingsContainer(
            onPressed: () {
              nextScreenPush(context, const AboutView());
            },
            leftWidget: Text(
              'About dReader',
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
