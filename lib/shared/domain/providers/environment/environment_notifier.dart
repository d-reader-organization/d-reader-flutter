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
    Map<String, WalletData>? wallets = walletsMapFromDynamic(networkData);
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
      wallets: wallets,
      walletAuthTokenMap: parsedWalletAuthTokens != null
          ? parsedWalletAuthTokens.map(
              (key, value) => MapEntry(key, value),
            )
          : wallets?.map(
              (key, value) => MapEntry(
                key,
                value.authToken,
              ),
            ),
    );
  }

  bool updateEnvironmentState(EnvironmentStateUpdateInput input) {
    final localStore = LocalStore.instance;

    state = state.copyWith(
      authToken: input.authToken,
      jwtToken: input.jwtToken,
      refreshToken: input.refreshToken,
      solanaCluster: input.solanaCluster,
      publicKey: input.publicKey,
      wallets: input.wallets,
      user: input.user,
      walletAuthTokenMap: input.walletAuthTokenMap,
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
      wallets: null,
    );
    putStateIntoLocalStore();
  }

  void clearPublicKey() {
    state.publicKey = null;
  }

  void clearTokenFromLocalStore() {
    final localStore = LocalStore.instance;
    localStore.delete(Config.tokenKey);
  }
}
