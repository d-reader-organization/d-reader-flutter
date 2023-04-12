import 'dart:convert';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final environmentProvider =
    StateNotifierProvider<EnvironmentNotifier, EnvironmentState>((ref) {
  return EnvironmentNotifier(
    EnvironmentState(
      apiUrl: Config.prodApiUrl,
      selectedNetwork: 'mainnet-beta',
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
          'selected-network',
        ) ??
        SolanaCluster.mainnet.value;

    if (selectedNetwork == SolanaCluster.devnet.value) {
      var devNetwork = jsonDecode(
        _sharedPreferences?.getString('dev-network') ?? '{}',
      );
      if (devNetwork != null) {
        state = state.copyWith(
          apiUrl: Config.devApiUrl,
          authToken: devNetwork['authToken'],
          jwtToken: devNetwork['jwtToken'],
          refreshToken: devNetwork['refreshToken'],
          solanaCluster: SolanaCluster.devnet.value,
        );
      }
    } else {
      var prodNetwork = jsonDecode(
        _sharedPreferences?.getString('prod-network') ?? '{}',
      );
      if (prodNetwork != null) {
        state = state.copyWith(
          apiUrl: Config.prodApiUrl,
          authToken: prodNetwork['authToken'],
          jwtToken: prodNetwork['jwtToken'],
          refreshToken: prodNetwork['refreshToken'],
          solanaCluster: SolanaCluster.mainnet.value,
        );
      }
    }
  }

  void updateEnvironmentState(EnvironmentStateUpdateInput input) {
    state = state.copyWith(
      authToken: input.authToken,
      apiUrl: input.apiUrl,
      jwtToken: input.jwtToken,
      refreshToken: input.refreshToken,
      solanaCluster: input.solanaCluster,
    );

    _sharedPreferences?.setString(
      input.solanaCluster == SolanaCluster.devnet.value
          ? 'dev-network'
          : 'prod-network',
      jsonEncode(
        state.toJson(),
      ),
    );
    if (input.jwtToken != null) {
      _sharedPreferences?.setString(Config.tokenKey, input.jwtToken ?? '');
    }
  }

  void updateSelectedNetwork(String selectedNetwork) {
    _sharedPreferences?.setString('selected-network', selectedNetwork);
    state = state.copyWith(selectedNetwork: selectedNetwork);
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
