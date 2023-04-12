import 'package:solana/solana.dart' show Ed25519HDPublicKey;

class EnvironmentState {
  final String apiUrl, selectedNetwork, solanaCluster;
  final String? authToken, jwtToken, refreshToken;
  Ed25519HDPublicKey? publicKey;

  EnvironmentState({
    required this.apiUrl,
    required this.solanaCluster,
    required this.selectedNetwork,
    this.authToken,
    this.jwtToken,
    this.refreshToken,
    this.publicKey,
  });

  EnvironmentState copyWith({
    String? authToken,
    String? jwtToken,
    String? refreshToken,
    String? apiUrl,
    String? solanaCluster,
    String? selectedNetwork,
  }) {
    return EnvironmentState(
      authToken: authToken ?? this.authToken,
      jwtToken: jwtToken ?? this.jwtToken,
      refreshToken: refreshToken ?? this.refreshToken,
      apiUrl: apiUrl ?? this.apiUrl,
      solanaCluster: solanaCluster ?? this.solanaCluster,
      selectedNetwork: selectedNetwork ?? this.selectedNetwork,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['authToken'] = authToken;
    data['jwtToken'] = jwtToken;
    data['refreshToken'] = refreshToken;
    data['apiUrl'] = apiUrl;
    data['solanaCluster'] = solanaCluster;
    data['selectedNetwork'] = selectedNetwork;

    return data;
  }
}

class EnvironmentStateUpdateInput {
  final String? authToken,
      apiUrl,
      jwtToken,
      refreshToken,
      selectedNetwork,
      solanaCluster;
  final Ed25519HDPublicKey? publicKey;

  EnvironmentStateUpdateInput({
    this.authToken,
    this.jwtToken,
    this.refreshToken,
    this.apiUrl,
    this.solanaCluster,
    this.selectedNetwork,
    this.publicKey,
  });
}
