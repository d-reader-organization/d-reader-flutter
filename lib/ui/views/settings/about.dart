import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/main.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/launch_external_url.dart';
import 'package:d_reader_flutter/ui/widgets/settings/list_tile.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      appBarTitle: 'About dReader',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 8,
          ),
          Image.asset(
            Config.logoPath,
            height: 64,
            width: 64,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            packageInfo?.appName ?? 'dReader',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            'Version ${packageInfo?.version ?? 1.0}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ColorPalette.greyscale100,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(
            thickness: 1,
            color: Color(0xFF35383F),
          ),
          SettingsCommonListTile(
            title: 'Help Center',
            leadingPath: '${Config.settingsAssetsPath}/light/info_square.svg',
            onTap: () {
              openUrl(Config.helpCenterLink);
            },
          ),
          SettingsCommonListTile(
            title: 'Privacy Policy',
            leadingPath: '${Config.settingsAssetsPath}/light/shield_done.svg',
            onTap: () {
              openUrl(Config.privacyPolicyUrl);
            },
          ),
          const SettingsCommonListTile(
            title: 'Terms of Services',
            leadingPath: '${Config.settingsAssetsPath}/light/password.svg',
          ),
          SettingsCommonListTile(
            title: 'Twitter',
            overrideLeading: Container(
              margin: const EdgeInsets.only(top: 2),
              child: SvgPicture.asset(
                '${Config.settingsAssetsPath}/light/twitter.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            leadingPath: '${Config.settingsAssetsPath}/light/twitter.svg',
            onTap: () {
              openUrl(Config.twitterUrl);
            },
          ),
          SettingsCommonListTile(
            title: 'Discord',
            overrideLeading: Container(
              margin: const EdgeInsets.only(top: 4),
              child: SvgPicture.asset(
                '${Config.settingsAssetsPath}/light/discord.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            leadingPath: '${Config.settingsAssetsPath}/light/discord.svg',
            onTap: () {
              openUrl(Config.discordUrl);
            },
          ),
        ],
      ),
    );
  }
}
