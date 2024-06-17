import 'dart:convert';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_wallet_notifier.dart';
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:d_reader_flutter/features/user/domain/models/user.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/solana.dart';
part 'environment_notifier.g.dart';

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

@Riverpod(keepAlive: true)
class Environment extends _$Environment {
  @override
  EnvironmentState build() {
    state = EnvironmentState.empty();
    ref.read(localWalletNotifierProvider);
    final localStore = LocalStore.instance;
    const bool isProd = appFlavor != null && appFlavor == 'prod';
    final String selectedNetwork =
        isProd ? SolanaCluster.mainnet.value : SolanaCluster.devnet.value;
    final localStoreData = localStore.get(
      selectedNetwork == SolanaCluster.mainnet.value
          ? 'prod-network'
          : 'dev-network',
      defaultValue: null,
    );

    if (localStoreData == null) {
      return EnvironmentState(
        solanaCluster: selectedNetwork,
      );
    }

    var networkData = jsonDecode(localStoreData);
    Map<String, dynamic>? parsedWalletAuthTokens =
        networkData['walletAuthTokenMap'] != null
            ? jsonDecode(networkData['walletAuthTokenMap'])
            : null;
    return state.copyWith(
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
      walletAuthTokenMap: parsedWalletAuthTokens?.map(
        (key, value) => MapEntry(key, value),
      ),
    );
  }

  bool updateEnvironmentState(EnvironmentStateUpdateInput input) {
    state = state.copyWith(
      authToken: input.authToken,
      jwtToken: input.jwtToken,
      refreshToken: input.refreshToken,
      solanaCluster: input.solanaCluster,
      publicKey: input.publicKey,
      user: input.user,
      walletAuthTokenMap: input.walletAuthTokenMap,
    );

    putStateIntoLocalStore();
    return true;
  }

  void updatePublicKeyFromBase58(String address) {
    state = state.copyWith(publicKey: Ed25519HDPublicKey.fromBase58(address));
  }

  void putStateIntoLocalStore() {
    final bool isDevnet = state.solanaCluster == SolanaCluster.devnet.value;
    final localStore = LocalStore.instance;
    localStore.put(
      isDevnet ? 'dev-network' : 'prod-network',
      jsonEncode(
        state.toJson(),
      ),
    );
    localStore.put('last-network', state.solanaCluster);
  }

  void updateForChangeNetwork({
    required String cluster,
    Ed25519HDPublicKey? publicKey,
  }) {
    state = state.copyWithNullables(
      solanaCluster: cluster,
      publicKey: publicKey,
    );
    putStateIntoLocalStore();
  }

  void onLogout() {
    state = state.copyWithNullables(
      solanaCluster: state.solanaCluster,
      authToken: state.authToken,
      walletAuthTokenMap: state.walletAuthTokenMap,
      jwtToken: null,
      publicKey: null,
      refreshToken: null,
      user: null,
    );
    putStateIntoLocalStore();
  }

  void clearPublicKey() {
    state.publicKey = null;
  }
}
