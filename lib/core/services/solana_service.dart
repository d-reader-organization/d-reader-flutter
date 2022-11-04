import 'dart:convert' show utf8;

import 'package:d_reader_flutter/core/repositories/auth/auth_repository_impl.dart';
import 'package:solana/base58.dart';
import 'package:solana/solana.dart';

final List<int> privateKey = [
  147,
  128,
  131,
  149,
  98,
  75,
  218,
  125,
  69,
  54,
  146,
  152,
  174,
  153,
  180,
  30,
  133,
  11,
  62,
  196,
  134,
  30,
  116,
  159,
  129,
  32,
  58,
  31,
  201,
  216,
  249,
  205
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
          _keyPair.address, base58encode(signedData.bytes));
      return connectWalletResponse?.accessToken ?? 'no-token';
    } catch (e) {
      print(e);
      return 'An error occured.';
    }
  }
}
