import 'dart:convert' show jsonEncode;

import 'package:d_reader_flutter/core/models/auth.dart';
import 'package:d_reader_flutter/core/models/buy_nft_input.dart';
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

  Future<String> getOneTimePassword({
    required Ed25519HDPublicKey publicKey,
    required String name,
    String? referrer,
  }) async {
    return await IoCContainer.resolveContainer<AuthRepositoryImpl>()
        .getOneTimePassword(
      address: publicKey.toBase58(),
      name: name,
      referrer: referrer,
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
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> getNftTransaction(String candyMachineAddress) async {
    return await IoCContainer.resolveContainer<CandyMachineRepositoryImpl>()
        .constructNftTransaction(candyMachineAddress);
  }

  Future<String?> listItem({
    required String mintAccount,
    required int price,
    String? printReceipt,
  }) async {
    return IoCContainer.resolveContainer<AuctionHouseRepositoryImpl>().listItem(
        mintAccount: mintAccount, price: price, printReceipt: printReceipt);
  }

  Future<String?> delistItem({required String mint}) {
    return IoCContainer.resolveContainer<AuctionHouseRepositoryImpl>()
        .delistItem(mint: mint);
  }

  Future<String?> buyItem({
    required String mintAccount,
    required int price,
    required String seller,
  }) {
    return IoCContainer.resolveContainer<AuctionHouseRepositoryImpl>().buyItem(
      mintAccount: mintAccount,
      price: price,
      seller: seller,
    );
  }

  Future<List<String>> buyMultipleItems(List<BuyNftInput> input) {
    Map<String, String> query = {};
    for (int i = 0; i < input.length; ++i) {
      query["instantBuyParams[$i]"] = jsonEncode(input[i].toJson());
    }

    return IoCContainer.resolveContainer<AuctionHouseRepositoryImpl>()
        .buyMultipleItems(query);
  }
}
