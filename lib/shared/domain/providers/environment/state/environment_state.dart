import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/user/domain/models/user.dart';
import 'package:solana/solana.dart';

Map<String, WalletData>? walletsMapFromDynamic(dynamic json) {
  Map<String, dynamic>? storedWallets =
      json['wallets'] != null ? jsonDecode(json['wallets']) : null;
  return storedWallets?.map(
    (key, value) => MapEntry(
      key,
      WalletData.fromJson(
        value,
      ),
    ),
  );
}

class WalletData {
  // TODO think of removing this to be backward compatible
  final String authToken;

  WalletData({
    required this.authToken,
  });

  factory WalletData.fromJson(dynamic json) {
    return WalletData(
      authToken: json['authToken'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['authToken'] = authToken;
    return data;
  }
}

class EnvironmentState {
  final UserModel? user;
  final String apiUrl, solanaCluster;
  final String? authToken, jwtToken, refreshToken;
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
    this.wallets,
  });

  EnvironmentState copyWith({
    UserModel? user,
    String? apiUrl,
    String? authToken,
    String? jwtToken,
    String? refreshToken,
    String? solanaCluster,
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
    data['user'] = user != null ? jsonEncode(user) : null;
    data['wallets'] = wallets != null ? jsonEncode(wallets) : null;
    return data;
  }
}

class EnvironmentStateUpdateInput {
  final UserModel? user;
  final String? apiUrl, authToken, jwtToken, refreshToken, solanaCluster;
  final Ed25519HDPublicKey? publicKey;
  Map<String, WalletData>? wallets;

  EnvironmentStateUpdateInput({
    this.user,
    this.apiUrl,
    this.authToken,
    this.jwtToken,
    this.refreshToken,
    this.solanaCluster,
    this.publicKey,
    this.wallets,
  });

  factory EnvironmentStateUpdateInput.fromDynamic(dynamic data) {
    final dynamic json = jsonDecode(data);
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
