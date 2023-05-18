import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
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
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: 'Are you sure you want to change network?',
          subtitle: subtitle,
        );
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
                final isConfirmed = await _showDialog(
                      context: context,
                      subtitle: 'Make sure to switch your wallet to Mainnet.',
                    ) ??
                    false;
                if (isConfirmed) {
                  final dynamic localStoreData = ref.read(
                    localStoreNetworkDataProvider(SolanaCluster.mainnet.value),
                  );
                  bool isSuccessful = false;
                  if (localStoreData != null) {
                    isSuccessful = ref
                        .read(environmentProvider.notifier)
                        .updateEnvironmentState(
                          EnvironmentStateUpdateInput.fromDynamic(
                            localStoreData,
                          ),
                        );
                  } else {
                    isSuccessful = await ref
                            .read(solanaProvider.notifier)
                            .authorizeAndSignMessage(
                                SolanaCluster.mainnet.value) ==
                        'OK';
                  }
                  if (context.mounted) {
                    final snackbarText = isSuccessful
                        ? 'Network changed successfully'
                        : 'Network change failed.';
                    if (!isSuccessful) {
                      ref
                          .read(environmentProvider.notifier)
                          .updateEnvironmentState(
                            EnvironmentStateUpdateInput(
                              solanaCluster: SolanaCluster.devnet.value,
                            ),
                          );
                    } else {
                      ref.invalidate(myWalletProvider);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(snackbarText),
                        backgroundColor: isSuccessful
                            ? ColorPalette.dReaderGreen
                            : ColorPalette.dReaderRed,
                      ),
                    );
                  }
                }
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
                final isConfirmed = await _showDialog(
                      context: context,
                      subtitle: 'Make sure to switch your wallet to Devnet.',
                    ) ??
                    false;
                if (isConfirmed) {
                  final dynamic localStoreData = ref.read(
                    localStoreNetworkDataProvider(SolanaCluster.devnet.value),
                  );
                  bool isSuccessful = false;
                  if (localStoreData != null) {
                    isSuccessful = ref
                        .read(environmentProvider.notifier)
                        .updateEnvironmentState(
                          EnvironmentStateUpdateInput.fromDynamic(
                            localStoreData,
                          ),
                        );
                  } else {
                    isSuccessful = await ref
                            .read(solanaProvider.notifier)
                            .authorizeAndSignMessage(
                              SolanaCluster.devnet.value,
                            ) ==
                        'OK';
                  }
                  if (context.mounted) {
                    final snackbarText = isSuccessful
                        ? 'Network changed successfully'
                        : 'Network change failed.';
                    if (!isSuccessful) {
                      ref
                          .read(environmentProvider.notifier)
                          .updateEnvironmentState(
                            EnvironmentStateUpdateInput(
                              solanaCluster: SolanaCluster.mainnet.value,
                            ),
                          );
                    } else {
                      ref.invalidate(myWalletProvider);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(snackbarText),
                        backgroundColor: isSuccessful
                            ? ColorPalette.dReaderGreen
                            : ColorPalette.dReaderRed,
                      ),
                    );
                  }
                }
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
