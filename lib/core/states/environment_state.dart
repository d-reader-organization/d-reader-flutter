import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/config/config.dart';
import 'package:solana/solana.dart' show Ed25519HDPublicKey;

class EnvironmentState {
  final String apiUrl, solanaCluster;
  final String? authToken, jwtToken, refreshToken, signature;
  Ed25519HDPublicKey? publicKey;

  EnvironmentState({
    this.apiUrl = Config.apiUrl,
    required this.solanaCluster,
    this.authToken,
    this.jwtToken,
    this.refreshToken,
    this.publicKey,
    this.signature,
  });

  EnvironmentState copyWith({
    String? apiUrl,
    String? authToken,
    String? jwtToken,
    String? refreshToken,
    String? solanaCluster,
    List<int>? signature,
    Ed25519HDPublicKey? publicKey,
  }) {
    return EnvironmentState(
      apiUrl: apiUrl ?? this.apiUrl,
      authToken: authToken ?? this.authToken,
      jwtToken: jwtToken ?? this.jwtToken,
      refreshToken: refreshToken ?? this.refreshToken,
      solanaCluster: solanaCluster ?? this.solanaCluster,
      publicKey: publicKey ?? this.publicKey,
      signature:
          signature != null ? String.fromCharCodes(signature) : this.signature,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['apiUrl'] = apiUrl;
    data['authToken'] = authToken;
    data['jwtToken'] = jwtToken;
    data['refreshToken'] = refreshToken;
    data['solanaCluster'] = solanaCluster;
    data['publicKey'] = publicKey?.toBase58();
    data['signature'] = signature;

    return data;
  }
}

class EnvironmentStateUpdateInput {
  final String? apiUrl, authToken, jwtToken, refreshToken, solanaCluster;
  final Ed25519HDPublicKey? publicKey;
  final List<int>? signature;

  EnvironmentStateUpdateInput({
    this.apiUrl,
    this.authToken,
    this.jwtToken,
    this.refreshToken,
    this.solanaCluster,
    this.publicKey,
    this.signature,
  });

  factory EnvironmentStateUpdateInput.fromDynamic(dynamic data) {
    final dynamic json = jsonDecode(data);
    final String? signature = json['signature'];

    return EnvironmentStateUpdateInput(
      apiUrl: json['apiUrl'],
      authToken: json['authToken'],
      jwtToken: json['jwtToken'],
      refreshToken: json['refreshToken'],
      publicKey: Ed25519HDPublicKey.fromBase58(json['publicKey']),
      solanaCluster: json['solanaCluster'],
      signature: signature?.codeUnits,
    );
  }
}
