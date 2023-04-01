import 'package:d_reader_flutter/core/repositories/auction_house/repository_impl.dart';
import 'package:d_reader_flutter/core/repositories/auth/auth_repository_impl.dart';
import 'package:d_reader_flutter/core/repositories/candy_machine/repository_implementation.dart';
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

  Future<String?> getNftTransaction(String candyMachineAddress) async {
    return await IoCContainer.resolveContainer<CandyMachineRepositoryImpl>()
        .constructNftTransaction(candyMachineAddress);
  }

  Future<String?> listItem({
    required String mintAccount,
    required double price,
    String? printReceipt,
  }) async {
    return IoCContainer.resolveContainer<AuctionHouseRepositoryImpl>().listItem(
        mintAccount: mintAccount, price: price, printReceipt: printReceipt);
  }

  Future<String?> delistItem({required String query}) {
    return IoCContainer.resolveContainer<AuctionHouseRepositoryImpl>()
        .delistItem(query: query);
  }
}
