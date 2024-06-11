import 'package:d_reader_flutter/features/wallet/domain/models/local_wallet/key_pair_params.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/local_wallet/local_wallet.dart';
import 'package:flutter/foundation.dart';
import 'package:solana/solana.dart';

Future<LocalWallet> createLocalWallet({required String mnemonic}) async {
  final wallet = await compute(_createKeyPair, KeyPairParams(mnemonic, 0, 0));

  return LocalWalletImpl(wallet);
}

Future<Ed25519HDKeyPair> _createKeyPair(KeyPairParams params) =>
    Ed25519HDKeyPair.fromMnemonic(
      params.mnemonic,
      change: params.change,
      account: params.account,
    );
