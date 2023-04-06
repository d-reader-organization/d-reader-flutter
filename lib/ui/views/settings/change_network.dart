import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/settings/container.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:flutter/material.dart';

class ChangeNetworkView extends StatelessWidget {
  const ChangeNetworkView({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      body: Column(
        children: [
          SettingsContainer(
            leftWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Mainnet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Main dReader Network',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            rightWidget: const Icon(
              Icons.check_circle,
              color: ColorPalette.dReaderYellow100,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          SettingsContainer(
            leftWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Devnet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Dev dReader Network',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            rightWidget: const Icon(
              Icons.check_circle,
              color: ColorPalette.boxBackground400,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          const SettingsContainer(
            leftWidget: Text(
              'Testnet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey,
              ),
            ),
            rightWidget: SizedBox(),
          ),
        ],
      ),
      appBarTitle: 'Change Network',
    );
  }
}
