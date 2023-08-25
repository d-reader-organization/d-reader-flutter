import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:solana/solana.dart';

SolanaClient createSolanaClient({required String rpcUrl}) {
  return SolanaClient(
    rpcUrl: Uri.parse(
      rpcUrl,
    ),
    websocketUrl: Uri.parse(
      rpcUrl.replaceAll(
        'https',
        'ws',
      ),
    ),
  );
}

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
