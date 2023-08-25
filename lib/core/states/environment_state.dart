import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/utils/utils.dart';
import 'package:solana/solana.dart' show Ed25519HDPublicKey;

class EnvironmentState {
  final UserModel? user;
  final String apiUrl, solanaCluster;
  final String? authToken, jwtToken, refreshToken, signature;
  final Map<String, WalletData>? wallets;
  Ed25519HDPublicKey? publicKey;

  EnvironmentState({
    this.apiUrl = Config.apiUrl,
    required this.solanaCluster,
    this.user,
    this.authToken,
    this.jwtToken,
    this.refreshToken,
    this.publicKey,
    this.signature,
    this.wallets,
  });

  EnvironmentState copyWith({
    UserModel? user,
    String? apiUrl,
    String? authToken,
    String? jwtToken,
    String? refreshToken,
    String? solanaCluster,
    List<int>? signature,
    Ed25519HDPublicKey? publicKey,
    Map<String, WalletData>? wallets,
  }) {
    return EnvironmentState(
      user: user ?? this.user,
      apiUrl: apiUrl ?? this.apiUrl,
      authToken: authToken ?? this.authToken,
      jwtToken: jwtToken ?? this.jwtToken,
      refreshToken: refreshToken ?? this.refreshToken,
      solanaCluster: solanaCluster ?? this.solanaCluster,
      publicKey: publicKey ?? this.publicKey,
      signature:
          signature != null ? String.fromCharCodes(signature) : this.signature,
      wallets: wallets ?? this.wallets,
    );
  }

  EnvironmentState copyWithNullables({
    UserModel? user,
    required String apiUrl,
    String? authToken,
    String? jwtToken,
    String? refreshToken,
    required String solanaCluster,
    List<int>? signature,
    Ed25519HDPublicKey? publicKey,
    Map<String, WalletData>? wallets,
  }) {
    return EnvironmentState(
      user: user,
      apiUrl: apiUrl,
      authToken: authToken,
      jwtToken: jwtToken,
      refreshToken: refreshToken,
      solanaCluster: solanaCluster,
      publicKey: publicKey,
      signature: signature != null ? String.fromCharCodes(signature) : null,
      wallets: wallets,
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
    data['user'] = user != null ? jsonEncode(user) : null;
    data['wallets'] = wallets != null ? jsonEncode(wallets) : null;
    return data;
  }
}

class EnvironmentStateUpdateInput {
  final UserModel? user;
  final String? apiUrl, authToken, jwtToken, refreshToken, solanaCluster;
  final Ed25519HDPublicKey? publicKey;
  final List<int>? signature;
  Map<String, WalletData>? wallets;

  EnvironmentStateUpdateInput({
    this.user,
    this.apiUrl,
    this.authToken,
    this.jwtToken,
    this.refreshToken,
    this.solanaCluster,
    this.publicKey,
    this.signature,
    this.wallets,
  });

  factory EnvironmentStateUpdateInput.fromDynamic(dynamic data) {
    final dynamic json = jsonDecode(data);
    final String? signature = json['signature'];
    Map<String, WalletData>? wallets = walletsMapFromDynamic(json);
    return EnvironmentStateUpdateInput(
      apiUrl: json['apiUrl'],
      authToken: json['authToken'],
      jwtToken: json['jwtToken'],
      refreshToken: json['refreshToken'],
      publicKey: json['publicKey'] != null
          ? Ed25519HDPublicKey.fromBase58(json['publicKey'])
          : null,
      solanaCluster: json['solanaCluster'],
      signature: signature?.codeUnits,
      wallets: wallets,
      user: json['user'] != null
          ? UserModel.fromJson(
              jsonDecode(
                json['user'],
              ),
            )
          : null,
    );
  }
}

class WalletData {
  final String authToken, signature;

  WalletData({
    required this.authToken,
    required this.signature,
  });

  factory WalletData.fromJson(dynamic json) {
    return WalletData(
      authToken: json['authToken'],
      signature: json['signature'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['authToken'] = authToken;
    data['signature'] = signature;
    return data;
  }
}
