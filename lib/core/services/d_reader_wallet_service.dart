import 'package:d_reader_flutter/core/repositories/auth/auth_repository_impl.dart';
import 'package:d_reader_flutter/core/repositories/playground/playground_repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:solana/base58.dart';
import 'package:solana/solana.dart';

class DReaderWalletService {
  DReaderWalletService._();

  static final DReaderWalletService _instance = DReaderWalletService._();
  static DReaderWalletService get instance => _instance;

  Future<String> getOneTimePassword(Ed25519HDPublicKey publicKey) async {
    return await IoCContainer.resolveContainer<AuthRepositoryImpl>()
        .getOneTimePassword(publicKey.toBase58());
  }

  Future<String> connectWallet(
      Ed25519HDPublicKey publicKey, List<int> signedData) async {
    try {
      final connectWalletResponse =
          await IoCContainer.resolveContainer<AuthRepositoryImpl>()
              .connectWallet(
        publicKey.toBase58(),
        base58encode(signedData),
      );
      return connectWalletResponse?.accessToken ?? 'no-token';
    } catch (e) {
      print(e);
      return 'An error occured.';
    }
  }

  Future<String?> getNftTransaction() async {
    return await IoCContainer.resolveContainer<PlaygroundRepositoryImpl>()
        .constructNftTransaction();
  }
}
