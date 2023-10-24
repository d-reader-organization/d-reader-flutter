import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/ui/utils/launch_external_url.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/settings/profile/profile.dart';
import 'package:d_reader_flutter/ui/views/settings/about.dart';
import 'package:d_reader_flutter/ui/views/settings/change_network.dart';
import 'package:d_reader_flutter/ui/views/settings/referrals.dart';
import 'package:d_reader_flutter/ui/views/settings/wallet/wallet_list.dart';
import 'package:d_reader_flutter/ui/widgets/settings/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsRootView extends StatelessWidget {
  const SettingsRootView({
    super.key,
  });

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
              leadingPath: '${Config.settingsAssetsPath}/light/user.svg',
              title: 'My profile',
              onTap: () {
                nextScreenPush(context, const ProfileView());
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                return SettingsCommonListTile(
                  leadingPath: '${Config.settingsAssetsPath}/light/wallet.svg',
                  title: 'Wallet',
                  onTap: () async {
                    final user = await ref.read(myUserProvider.future);
                    if (context.mounted && user != null) {
                      nextScreenPush(
                        context,
                        WalletListScreen(
                          userId: user.id,
                        ),
                      );
                    }
                  },
                );
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
            SettingsCommonListTile(
              leadingPath: '${Config.settingsAssetsPath}/light/shield_done.svg',
              title: 'Security & Privacy',
              onTap: () {
                openUrl(
                  Config.privacyPolicyUrl,
                );
              },
            ),
            SettingsCommonListTile(
              leadingPath: '${Config.settingsAssetsPath}/light/3_user.svg',
              title: 'Referrals',
              onTap: () {
                nextScreenPush(
                  context,
                  const ReferralsView(),
                );
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                final userRole = ref.watch(environmentProvider).user?.role;
                return userRole == UserRole.tester.name ||
                        ref.watch(environmentProvider).apiUrl.contains('dev')
                    ? SettingsCommonListTile(
                        leadingPath:
                            '${Config.settingsAssetsPath}/light/network.svg',
                        title: 'Change Network',
                        onTap: () {
                          nextScreenPush(context, const ChangeNetworkView());
                        },
                      )
                    : const SizedBox();
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
