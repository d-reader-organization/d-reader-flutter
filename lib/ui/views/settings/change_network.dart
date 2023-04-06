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
        children: const [
          SettingsContainer(
            leftWidget: Text(
              'Mainnet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            rightWidget: Icon(
              Icons.check_circle,
              color: ColorPalette.dReaderYellow100,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          SettingsContainer(
            leftWidget: Text(
              'Devnet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            rightWidget: Icon(
              Icons.check_circle,
              color: ColorPalette.boxBackground400,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          SettingsContainer(
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
