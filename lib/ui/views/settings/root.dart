import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/profile.dart';
import 'package:d_reader_flutter/ui/views/settings/about.dart';
import 'package:d_reader_flutter/ui/views/settings/change_network.dart';
import 'package:d_reader_flutter/ui/widgets/settings/container.dart';
import 'package:flutter/material.dart';

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
            rightWidget: Row(
              children: const [
                Text(
                  'Mainnet',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
              ],
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
