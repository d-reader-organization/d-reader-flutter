import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/profile.dart';
import 'package:d_reader_flutter/ui/views/settings/about.dart';
import 'package:d_reader_flutter/ui/views/settings/change_network.dart';
import 'package:d_reader_flutter/ui/widgets/settings/list_tile.dart';
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
      padding: const EdgeInsets.only(right: 8, bottom: 4),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SettingsCommonListTile(
              leadingPath: '${Config.settingsAssetsPath}/light/wallet.svg',
              title: 'Wallet',
              onTap: () {
                nextScreenPush(context, const ProfileView());
              },
            ),
            const SettingsCommonListTile(
              leadingPath: '${Config.settingsAssetsPath}/light/document.svg',
              title: 'Address Book',
            ),
            const SettingsCommonListTile(
              leadingPath:
                  '${Config.settingsAssetsPath}/light/notification.svg',
              title: 'Notifications',
            ),
            const SettingsCommonListTile(
              leadingPath: '${Config.settingsAssetsPath}/light/shield_done.svg',
              title: 'Security & Privacy',
            ),
            const SettingsCommonListTile(
              leadingPath: '${Config.settingsAssetsPath}/light/3_user.svg',
              title: 'Referrals',
            ),
            SettingsCommonListTile(
              leadingPath: '${Config.settingsAssetsPath}/light/network.svg',
              title: 'Change Network',
              onTap: () {
                nextScreenPush(context, const ChangeNetworkView());
              },
            ),
            SettingsCommonListTile(
              leadingPath: '${Config.settingsAssetsPath}/light/bun_bun.svg',
              title: 'About dReader',
              onTap: () {
                nextScreenPush(context, const AboutView());
              },
            ),
          ],
        ),
      ),
    );
  }
}
