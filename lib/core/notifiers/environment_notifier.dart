import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solana/solana.dart';

final environmentChangeProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, cluster) async {
  final localStore = LocalStore.instance;
  final envNotifier = ref.read(environmentProvider.notifier);
  bool isMainCluster = cluster == SolanaCluster.mainnet.value;
  final localStoreData = localStore
      .get(isMainCluster ? 'prod-network' : 'dev-network', defaultValue: null);

  if (localStoreData != null) {
    var networkData = jsonDecode(localStoreData);
    final String? signature = networkData['signature'];
    envNotifier.updateLastSelectedNetwork(cluster);
    envNotifier.updateEnvironmentState(
      EnvironmentStateUpdateInput(
        authToken: networkData['authToken'],
        jwtToken: networkData['jwtToken'],
        refreshToken: networkData['refreshToken'],
        publicKey: Ed25519HDPublicKey.fromBase58(networkData['publicKey']),
        solanaCluster: cluster,
        signature: signature?.codeUnits,
      ),
    );
  } else {
    final response = await ref
        .read(solanaProvider.notifier)
        .authorizeAndSignMessage(cluster);
    ref.read(networkChangeUpdateWallet);
    return response == 'OK';
  }
  return true;
});

final environmentProvider =
    StateNotifierProvider<EnvironmentNotifier, EnvironmentState>((ref) {
  return EnvironmentNotifier(
    EnvironmentState(
      solanaCluster: SolanaCluster.mainnet.value,
    ),
  )..init();
});

class EnvironmentNotifier extends StateNotifier<EnvironmentState> {
  EnvironmentNotifier(super.state);

  void init() {
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
        defaultValue: null);

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

  updateEnvironmentState(EnvironmentStateUpdateInput input) async {
    final localStore = LocalStore.instance;
    final bool isDevnet = input.solanaCluster == SolanaCluster.devnet.value ||
        state.solanaCluster == SolanaCluster.devnet.value;
    state = state.copyWith(
      apiUrl: isDevnet ? Config.apiUrlDevnet : Config.apiUrl,
      authToken: input.authToken,
      jwtToken: input.jwtToken,
      refreshToken: input.refreshToken,
      solanaCluster: input.solanaCluster,
      publicKey: input.publicKey,
      signature: input.signature,
    );
    localStore.put(
      isDevnet ? 'dev-network' : 'prod-network',
      jsonEncode(
        state.toJson(),
      ),
    );

    if (input.jwtToken != null) {
      localStore.put(Config.tokenKey, input.jwtToken);
    }
  }

  void updateLastSelectedNetwork(String selectedNetwork) {
    LocalStore.instance.put('last-network', selectedNetwork);
  }

// this is added just to get OTP from proper apiUrl
  Future updateTempNetwork(String tempNetwork) {
    return LocalStore.instance.put('temp-network', tempNetwork);
  }

  void clearTempNetwork() {
    LocalStore.instance.delete('temp-network');
  }

  Future<void> clearDataFromLocalStore() async {
    final localStore = LocalStore.instance;
    localStore.delete(Config.tokenKey);
    return await localStore.delete(
      state.solanaCluster == SolanaCluster.devnet.value
          ? 'dev-network'
          : 'prod-network',
    );
  }
}
