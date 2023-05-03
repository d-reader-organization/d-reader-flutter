import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solana/solana.dart';

final environmentChangeProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, cluster) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final envNotifier = ref.read(environmentProvider.notifier);

  bool isMainCluster = cluster == SolanaCluster.mainnet.value;
  String? sharedPrefData = sharedPreferences
      .getString(isMainCluster ? 'prod-network' : 'dev-network');

  if (sharedPrefData != null) {
    var networkData = jsonDecode(sharedPrefData);
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
  SharedPreferences? _sharedPreferences;

  void init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String selectedNetwork = _sharedPreferences?.getString(
          'last-network',
        ) ??
        SolanaCluster.mainnet.value;

    String? sharedPrefData = _sharedPreferences?.getString(
      selectedNetwork == SolanaCluster.mainnet.value
          ? 'prod-network'
          : 'dev-network',
    );

    if (sharedPrefData != null) {
      var networkData = jsonDecode(sharedPrefData);
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

  void updateEnvironmentState(EnvironmentStateUpdateInput input) async {
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

    _sharedPreferences?.setString(
      isDevnet ? 'dev-network' : 'prod-network',
      jsonEncode(
        state.toJson(),
      ),
    );

    if (input.jwtToken != null) {
      await _sharedPreferences?.setString(
          Config.tokenKey, input.jwtToken ?? '');
    }
  }

  void updateLastSelectedNetwork(String selectedNetwork) {
    _sharedPreferences?.setString('last-network', selectedNetwork);
  }

// this is added just to get OTP from proper apiUrl
  void updateTempNetwork(String tempNetwork) {
    _sharedPreferences?.setString('temp-network', tempNetwork);
  }

  void clearTempNetwork() {
    _sharedPreferences?.remove('temp-network');
  }

  Future<bool> clearDataFromSharedPref() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _sharedPreferences?.remove(Config.tokenKey);

    return await _sharedPreferences?.remove(
          state.solanaCluster == SolanaCluster.devnet.value
              ? 'dev-network'
              : 'prod-network',
        ) ??
        false;
  }
}
