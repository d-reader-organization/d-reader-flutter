import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/settings/list_tile.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:flutter/material.dart';

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
          const Text(
            'dReader',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            'Version 1.0',
            textAlign: TextAlign.center,
            style: TextStyle(
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
          const SettingsCommonListTile(
            title: 'Help Center',
            leadingPath: '${Config.settingsAssetsPath}/light/info_square.svg',
          ),
          const SettingsCommonListTile(
            title: 'Privacy Policy',
            leadingPath: '${Config.settingsAssetsPath}/light/shield_done.svg',
          ),
          const SettingsCommonListTile(
            title: 'Terms of Services',
            leadingPath: '${Config.settingsAssetsPath}/light/password.svg',
          ),
        ],
      ),
    );
  }
}
