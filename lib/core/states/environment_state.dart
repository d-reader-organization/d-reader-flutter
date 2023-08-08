import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/config/config.dart';
import 'package:solana/solana.dart' show Ed25519HDPublicKey;

class EnvironmentState {
  final String apiUrl, solanaCluster;
  final String? authToken, jwtToken, refreshToken, signature, userRole;
  final List<Map<String, WalletData>>? wallets;
  Ed25519HDPublicKey? publicKey;

  EnvironmentState({
    this.apiUrl = Config.apiUrl,
    required this.solanaCluster,
    this.authToken,
    this.jwtToken,
    this.refreshToken,
    this.publicKey,
    this.signature,
    this.wallets,
    this.userRole,
  });

  EnvironmentState copyWith({
    String? apiUrl,
    String? authToken,
    String? jwtToken,
    String? refreshToken,
    String? solanaCluster,
    String? userRole,
    List<int>? signature,
    Ed25519HDPublicKey? publicKey,
    List<Map<String, WalletData>>? wallets,
  }) {
    return EnvironmentState(
      apiUrl: apiUrl ?? this.apiUrl,
      authToken: authToken ?? this.authToken,
      jwtToken: jwtToken ?? this.jwtToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userRole: userRole ?? this.userRole,
      solanaCluster: solanaCluster ?? this.solanaCluster,
      publicKey: publicKey ?? this.publicKey,
      signature:
          signature != null ? String.fromCharCodes(signature) : this.signature,
      wallets: wallets ?? this.wallets,
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
    data['userRole'] = userRole;
    return data;
  }
}

class EnvironmentStateUpdateInput {
  final String? apiUrl,
      authToken,
      jwtToken,
      refreshToken,
      solanaCluster,
      userRole;
  final Ed25519HDPublicKey? publicKey;
  final List<int>? signature;
  List<Map<String, WalletData>>? wallets;

  EnvironmentStateUpdateInput({
    this.apiUrl,
    this.authToken,
    this.jwtToken,
    this.refreshToken,
    this.solanaCluster,
    this.publicKey,
    this.signature,
    this.wallets,
    this.userRole,
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
      wallets: json['wallets'],
      userRole: json['userRole'],
    );
  }
}

class WalletData {
  final String authToken, signature;

  WalletData({
    required this.authToken,
    required this.signature,
  });
}
