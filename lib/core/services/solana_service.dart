import 'dart:convert' show utf8;

import 'package:d_reader_flutter/core/repositories/auth/auth_repository_impl.dart';
import 'package:solana/base58.dart';
import 'package:solana/solana.dart';

final List<int> privateKey = [
  154,
  214,
  42,
  221,
  63,
  25,
  230,
  24,
  6,
  38,
  144,
  67,
  132,
  121,
  152,
  149,
  54,
  160,
  38,
  24,
  221,
  159,
  211,
  82,
  198,
  47,
  111,
  53,
  61,
  16,
  183,
  142
];

class SolanaService {
  SolanaService._();
  static SolanaService? _instance;
  late Ed25519HDKeyPair _keyPair;
  static SolanaService? get instance => _instance;

  static Future<void> loadInstance() async {
    _instance ??= await _create();
  }

  static Future<SolanaService> _create() async {
    _instance = SolanaService._();
    _instance!._keyPair =
        await Ed25519HDKeyPair.fromPrivateKeyBytes(privateKey: privateKey);
    return _instance!;
  }

  Future<String> connectWallet() async {
    final authRepo = AuthRepositoryImpl();
    final oneTimePassword = await authRepo.getOneTimePassword(_keyPair.address);
    try {
      final signedData = await _keyPair.sign(utf8.encode(oneTimePassword));
      final connectWalletResponse = await authRepo.connectWallet(
        _keyPair.address,
        base58encode(signedData.bytes),
      );
      return connectWalletResponse?.accessToken ?? 'no-token';
    } catch (e) {
      print(e);
      return 'An error occured.';
    }
  }
}
