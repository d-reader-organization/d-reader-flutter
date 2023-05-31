import 'package:d_reader_flutter/core/models/auth.dart';
import 'package:d_reader_flutter/core/repositories/auth/auth_repository_impl.dart';
import 'package:d_reader_flutter/core/repositories/candy_machine/repository_implementation.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/base58.dart';
import 'package:solana/solana.dart';

class DReaderWalletService {
  DReaderWalletService._();

  static final DReaderWalletService _instance = DReaderWalletService._();
  static DReaderWalletService get instance => _instance;

  Future<dynamic> getOneTimePassword({
    required Ed25519HDPublicKey publicKey,
  }) async {
    return await IoCContainer.resolveContainer<AuthRepositoryImpl>()
        .getOneTimePassword(
      address: publicKey.toBase58(),
    );
  }

  Future<AuthWallet?> connectWallet(
      Ed25519HDPublicKey publicKey, List<int> signedData) async {
    try {
      final connectWalletResponse =
          await IoCContainer.resolveContainer<AuthRepositoryImpl>()
              .connectWallet(
        publicKey.toBase58(),
        base58encode(signedData),
      );
      return connectWalletResponse;
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      return null;
    }
  }

  Future<String?> getNftTransaction(String candyMachineAddress) async {
    return await IoCContainer.resolveContainer<CandyMachineRepositoryImpl>()
        .constructNftTransaction(candyMachineAddress);
  }

  // Future<String?> listItem({
  //   required String mintAccount,
  //   required int price,
  //   String? printReceipt,
  // }) async {
  //   return IoCContainer.resolveContainer<AuctionHouseRepositoryImpl>().listItem(
  //       mintAccount: mintAccount, price: price, printReceipt: printReceipt);
  // }

  // Future<String?> delistItem({required String mint}) {
  //   return IoCContainer.resolveContainer<AuctionHouseRepositoryImpl>()
  //       .delistItem(mint: mint);
  // }

  // Future<String?> buyItem({
  //   required String mintAccount,
  //   required int price,
  //   required String seller,
  // }) {
  //   return IoCContainer.resolveContainer<AuctionHouseRepositoryImpl>().buyItem(
  //     mintAccount: mintAccount,
  //     price: price,
  //     seller: seller,
  //   );
  // }

  // Future<List<String>> buyMultipleItems(List<BuyNftInput> input) {
  //   Map<String, String> query = {};
  //   for (int i = 0; i < input.length; ++i) {
  //     query["instantBuyParams[$i]"] = jsonEncode(input[i].toJson());
  //   }

  //   return IoCContainer.resolveContainer<AuctionHouseRepositoryImpl>()
  //       .buyMultipleItems(query);
  // }
}
