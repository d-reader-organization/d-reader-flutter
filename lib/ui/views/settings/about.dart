import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/ui/widgets/settings/container.dart';
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
            height: 4,
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
            'Version 1.0.0',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const SettingsContainer(
            leftWidget: Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const SettingsContainer(
            leftWidget: Text(
              'Terms of Service',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const SettingsContainer(
            leftWidget: Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const SettingsContainer(
            leftWidget: Text(
              'Report an issue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
