import 'package:flutter/foundation.dart';
import 'package:solana/solana.dart';

abstract class LocalWallet {
  const LocalWallet();

  String get address;

  Ed25519HDPublicKey get publicKey;

  Future<List<Signature>> sign(Iterable<Uint8List> payloads);
}

class LocalWalletImpl implements LocalWallet {
  final Ed25519HDKeyPair keyPair;

  const LocalWalletImpl(this.keyPair);

  @override
  String get address => keyPair.address;

  @override
  Ed25519HDPublicKey get publicKey => keyPair.publicKey;

  @override
  Future<List<Signature>> sign(Iterable<Uint8List> payloads) =>
      Future.wait(payloads.map(keyPair.sign));
}
