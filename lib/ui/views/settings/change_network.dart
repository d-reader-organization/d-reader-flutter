import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/enums.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/carousel_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/core/providers/creator_provider.dart';
import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/views/intro/initial.dart';
import 'package:d_reader_flutter/ui/widgets/common/confirmation_dialog.dart';
import 'package:d_reader_flutter/ui/widgets/settings/network_list_tile.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChangeNetworkView extends ConsumerWidget {
  const ChangeNetworkView({super.key});

  Future<bool?> _showDialog({
    required BuildContext context,
    required String subtitle,
    required String cluster,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: 'Warning, switching to $cluster',
          subtitle: subtitle,
        );
      },
    );
  }

  _doChangeNetworkProcess({
    required BuildContext context,
    required WidgetRef ref,
    required String cluster,
    required String dialogText,
  }) {
    final dynamic localStoreData = ref.read(
      localStoreNetworkDataProvider(cluster),
    );
    final bool isDevnetCluster = cluster == SolanaCluster.devnet.value;
    ref.invalidate(environmentProvider);
    final envNotifier = ref.read(environmentProvider.notifier);
    envNotifier.updateForChangeNetwork(
      cluster: cluster,
      apiUrl: isDevnetCluster ? Config.apiUrlDevnet : Config.apiUrl,
    );
    if (localStoreData != null) {
      bool isSuccessful =
          ref.read(environmentProvider.notifier).updateEnvironmentState(
                EnvironmentStateUpdateInput.fromDynamic(
                  localStoreData,
                ),
              );
      if (context.mounted) {
        final snackbarText = isSuccessful
            ? 'Network changed successfully'
            : 'Network change failed.';
        if (!isSuccessful) {
          ref.read(environmentProvider.notifier).updateEnvironmentState(
                EnvironmentStateUpdateInput(
                  solanaCluster: isDevnetCluster
                      ? SolanaCluster.mainnet.value
                      : SolanaCluster.devnet.value,
                ),
              );
          return showSnackBar(
            context: context,
            text: snackbarText,
            backgroundColor: ColorPalette.dReaderRed,
          );
        }
        ref.invalidate(comicsProvider);
        ref.invalidate(comicIssuesProvider);
        ref.invalidate(creatorsProvider);
        ref.invalidate(carouselProvider);
        ref.invalidate(paginatedIssuesProvider);
        ref.invalidate(paginatedComicsProvider);
        return showSnackBar(
          context: context,
          text: snackbarText,
          backgroundColor: ColorPalette.dReaderGreen,
        );
      }
    } else {
      ref.invalidate(scaffoldProvider);
      if (context.mounted) {
        nextScreenCloseOthers(context, const InitialIntroScreen());
      }
    }
  }

  _handleNetworkChange({
    required BuildContext context,
    required WidgetRef ref,
    required String cluster,
    required String dialogText,
  }) async {
    final isAlreadyShown =
        LocalStore.instance.get(WalkthroughKeys.changeNetwork.name) != null;
    if (isAlreadyShown) {
      return _doChangeNetworkProcess(
        context: context,
        ref: ref,
        cluster: cluster,
        dialogText: dialogText,
      );
    }

    final isConfirmed = await _showDialog(
          context: context,
          subtitle: dialogText,
          cluster: cluster,
        ) ??
        false;
    if (isConfirmed && context.mounted) {
      LocalStore.instance.put(WalkthroughKeys.changeNetwork.name, true);
      _doChangeNetworkProcess(
        context: context,
        ref: ref,
        cluster: cluster,
        dialogText: dialogText,
      );
    }
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
