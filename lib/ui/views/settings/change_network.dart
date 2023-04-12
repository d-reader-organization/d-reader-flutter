import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/providers/selected_network_provider.dart';
import 'package:d_reader_flutter/ui/widgets/settings/network_list_tile.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChangeNetworkView extends ConsumerWidget {
  const ChangeNetworkView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String selectedNetwork = ref.watch(selectedNetworkProvider);
    return SettingsScaffold(
      body: Column(
        children: [
          NetworkListTile(
            title: 'Mainnet-beta',
            isSelected: selectedNetwork == SolanaCluster.mainnet.value,
            onTap: () {
              if (selectedNetwork != SolanaCluster.mainnet.value) {
                ref.read(selectedNetworkProvider.notifier).state =
                    SolanaCluster.mainnet.value;
              }
            },
          ),
          const SizedBox(
            height: 2,
          ),
          NetworkListTile(
            title: 'Devnet',
            isSelected: selectedNetwork == SolanaCluster.devnet.value,
            onTap: () {
              if (selectedNetwork != SolanaCluster.devnet.value) {
                ref.read(selectedNetworkProvider.notifier).state =
                    SolanaCluster.devnet.value;
              }
            },
          ),
          const SizedBox(
            height: 2,
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
