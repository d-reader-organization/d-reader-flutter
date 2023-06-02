import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solana/solana.dart';

final localStoreNetworkDataProvider =
    StateProvider.autoDispose.family<dynamic, String>(
  (ref, cluster) {
    final bool isMainCluster = cluster == SolanaCluster.mainnet.value;
    final localStoreData = LocalStore.instance.get(
      isMainCluster ? 'prod-network' : 'dev-network',
      defaultValue: null,
    );
    return localStoreData;
  },
);

// final environmentChangeProvider =
//     FutureProvider.family<bool, String>((ref, cluster) async {
//   final localStore = LocalStore.instance;
//   bool isMainCluster = cluster == SolanaCluster.mainnet.value;
//   final localStoreData = localStore
//       .get(isMainCluster ? 'prod-network' : 'dev-network', defaultValue: null);

//   if (localStoreData != null) {
//     var networkData = jsonDecode(localStoreData);
//     final String? signature = networkData['signature'];
//     ref.read(environmentProvider.notifier).updateEnvironmentState(
//           EnvironmentStateUpdateInput(
//             authToken: networkData['authToken'],
//             jwtToken: networkData['jwtToken'],
//             refreshToken: networkData['refreshToken'],
//             publicKey: Ed25519HDPublicKey.fromBase58(networkData['publicKey']),
//             solanaCluster: cluster,
//             signature: signature?.codeUnits,
//           ),
//         );
//   } else {
//     final response = await ref
//         .read(solanaProvider.notifier)
//         .authorizeAndSignMessage(cluster);
//     return response == 'OK';
//   }
//   return true;
// });

final environmentProvider =
    StateNotifierProvider<EnvironmentNotifier, EnvironmentState>((ref) {
  return EnvironmentNotifier(
    EnvironmentState(
      solanaCluster: SolanaCluster.mainnet.value,
    ),
  );
});

class EnvironmentNotifier extends StateNotifier<EnvironmentState> {
  EnvironmentNotifier(super.state) {
    final localStore = LocalStore.instance;
    String selectedNetwork = localStore.get(
          'last-network',
          defaultValue: null,
        ) ??
        SolanaCluster.mainnet.value;
    final localStoreData = localStore.get(
      selectedNetwork == SolanaCluster.mainnet.value
          ? 'prod-network'
          : 'dev-network',
      defaultValue: null,
    );

    if (localStoreData != null) {
      var networkData = jsonDecode(localStoreData);
      final String? signature = networkData['signature'];
      state = state.copyWith(
        apiUrl: selectedNetwork == SolanaCluster.devnet.value
            ? Config.apiUrlDevnet
            : Config.apiUrl,
        authToken: networkData['authToken'],
        jwtToken: networkData['jwtToken'],
        refreshToken: networkData['refreshToken'],
        publicKey: networkData['publicKey'] != null
            ? Ed25519HDPublicKey.fromBase58(networkData['publicKey'])
            : null,
        solanaCluster: selectedNetwork,
        signature: signature?.codeUnits,
      );
    }
  }

  bool updateEnvironmentState(EnvironmentStateUpdateInput input) {
    final localStore = LocalStore.instance;

    state = state.copyWith(
      apiUrl: input.apiUrl,
      authToken: input.authToken,
      jwtToken: input.jwtToken,
      refreshToken: input.refreshToken,
      solanaCluster: input.solanaCluster,
      publicKey: input.publicKey,
      signature: input.signature,
    );

    // localStore.put(
    //   isDevnet ? 'dev-network' : 'prod-network',
    //   jsonEncode(
    //     state.toJson(),
    //   ),
    // );

    if (input.jwtToken != null) {
      localStore.put(Config.tokenKey, input.jwtToken);
      putStateIntoLocalStore();
    }
    return true;
  }

  void putStateIntoLocalStore() {
    final bool isDevnet = state.solanaCluster == SolanaCluster.devnet.value;
    LocalStore.instance.put(
      isDevnet ? 'dev-network' : 'prod-network',
      jsonEncode(
        state.toJson(),
      ),
    );
    updateLastSelectedNetwork(state.solanaCluster);
  }

  void updateLastSelectedNetwork(String selectedNetwork) {
    LocalStore.instance.put('last-network', selectedNetwork);
  }

  Future<void> clearDataFromLocalStore(String cluster) async {
    final localStore = LocalStore.instance;
    localStore.delete(Config.tokenKey);
    return await localStore.delete(
      cluster == SolanaCluster.devnet.value ? 'dev-network' : 'prod-network',
    );
  }
}
