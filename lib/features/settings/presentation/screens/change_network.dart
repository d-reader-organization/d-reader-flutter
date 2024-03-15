import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/settings/presentation/providers/change_network.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:d_reader_flutter/features/settings/presentation/widgets/network_list_tile.dart';
import 'package:d_reader_flutter/features/settings/presentation/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChangeNetworkView extends ConsumerWidget {
  const ChangeNetworkView({super.key});

  Future<void> _handleNetworkChange({
    required BuildContext context,
    required WidgetRef ref,
    required String cluster,
    required String dialogText,
  }) async {
    await ref
        .read(changeNetworkControllerProvider.notifier)
        .handleNetworkChange(
          cluster: cluster,
          dialogText: dialogText,
          showConfirmDialog: (
              {required String cluster, required String subtitle}) async {
            return await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return ConfirmationDialog(
                      title: 'Warning, switching to $cluster',
                      subtitle: subtitle,
                    );
                  },
                ) ??
                false;
          },
          triggerChangeDialog: (
              {required bool isSuccess, required String text}) {
            showSnackBar(
              context: context,
              text: text,
              backgroundColor: isSuccess
                  ? ColorPalette.dReaderGreen
                  : ColorPalette.dReaderRed,
            );
          },
          triggerScreenChange: () {
            nextScreenCloseOthers(context: context, path: RoutePath.initial);
          },
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String selectedCluster = ref.watch(environmentProvider).solanaCluster;
    return SettingsScaffold(
      body: Column(
        children: [
          NetworkListTile(
            title: 'Mainnet-beta',
            isSelected: selectedCluster == SolanaCluster.mainnet.value,
            onTap: () async {
              if (selectedCluster != SolanaCluster.mainnet.value) {
                await _handleNetworkChange(
                  context: context,
                  ref: ref,
                  cluster: SolanaCluster.mainnet.value,
                  dialogText:
                      'Make sure your mobile wallet app is set to Mainnet before proceeding!',
                );
              }
            },
          ),
          const SizedBox(
            height: 4,
          ),
          NetworkListTile(
            title: 'Devnet',
            isSelected: selectedCluster == SolanaCluster.devnet.value,
            onTap: () async {
              if (selectedCluster != SolanaCluster.devnet.value) {
                await _handleNetworkChange(
                  context: context,
                  ref: ref,
                  cluster: SolanaCluster.devnet.value,
                  dialogText:
                      'Devnet is only used for testing purposes and assets don\'t have any value. Make sure your mobile wallet app is set to Devnet before proceeding!',
                );
              }
            },
          ),
          const SizedBox(
            height: 4,
          ),
          const NetworkListTile(
            title: 'Testnet',
            isSelected: false,
          ),
        ],
      ),
      appBarTitle: 'Change Network',
    );
  }
}
