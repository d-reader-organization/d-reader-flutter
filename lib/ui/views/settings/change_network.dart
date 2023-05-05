import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
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

  Future<bool?> _showDialog(
    BuildContext context,
    dynamic title,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: title,
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
                      context,
                      RichText(
                        text: const TextSpan(
                          text: 'Are you sure you want switch to ',
                          children: <TextSpan>[
                            TextSpan(
                              text: 'mainnet?\n',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                                text: 'Make sure to switch your wallet to '),
                            TextSpan(
                              text: 'mainnet.',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) ??
                    false;
                if (isConfirmed) {
                  final response = await ref.read(
                      environmentChangeProvider(SolanaCluster.mainnet.value)
                          .future);
                  if (context.mounted) {
                    final snackbarText = response
                        ? 'Network changed successfully'
                        : 'Network change failed.';
                    if (!response) {
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
                        backgroundColor: response
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
                      context,
                      RichText(
                        text: const TextSpan(
                          text: 'Are you sure you want switch to ',
                          children: <TextSpan>[
                            TextSpan(
                              text: 'devnet?\n',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                                text: 'Make sure to switch your wallet to '),
                            TextSpan(
                              text: 'devnet.',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) ??
                    false;
                if (isConfirmed) {
                  final response = await ref.read(
                      environmentChangeProvider(SolanaCluster.devnet.value)
                          .future);
                  if (context.mounted) {
                    final snackbarText = response
                        ? 'Network changed successfully'
                        : 'Network change failed.';
                    if (!response) {
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
                        backgroundColor: response
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
