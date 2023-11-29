import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:d_reader_flutter/core/utils/utils.dart';
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
      Map<String, WalletData>? wallets = walletsMapFromDynamic(networkData);
      state = state.copyWith(
        apiUrl: networkData['apiUrl'],
        authToken: networkData['authToken'],
        jwtToken: networkData['jwtToken'],
        refreshToken: networkData['refreshToken'],
        publicKey: networkData['publicKey'] != null
            ? Ed25519HDPublicKey.fromBase58(networkData['publicKey'])
            : null,
        solanaCluster: selectedNetwork,
        user: networkData['user'] != null
            ? UserModel.fromJson(jsonDecode(networkData['user']))
            : null,
        wallets: wallets,
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
      wallets: input.wallets,
      user: input.user,
    );

    if (input.jwtToken != null) {
      localStore.put(Config.tokenKey, input.jwtToken);
    }
    putStateIntoLocalStore();
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

  void updateForChangeNetwork({
    required String cluster,
    required String apiUrl,
    Ed25519HDPublicKey? publicKey,
  }) {
    state = state.copyWithNullables(
      apiUrl: apiUrl,
      solanaCluster: cluster,
      publicKey: publicKey,
    );
    putStateIntoLocalStore();
  }

  void clearPublicKey() {
    state.publicKey = null;
  }

  Future<void> clearDataFromLocalStore(String cluster) async {
    final localStore = LocalStore.instance;
    localStore.delete(Config.tokenKey);
    return await localStore.delete(
      cluster == SolanaCluster.devnet.value ? 'dev-network' : 'prod-network',
    );
  }
}
