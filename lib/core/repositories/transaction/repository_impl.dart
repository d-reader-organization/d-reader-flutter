import 'package:d_reader_flutter/core/repositories/transaction/repository.dart';
import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final Dio client;

  TransactionRepositoryImpl({
    required this.client,
  });

  @override
  Future<List<String>> buyMultipleItems(Map<String, dynamic> query) async {
    final responseBody = await client
        .get(
      '/transaction/multiple-buy',
      queryParameters: query,
    )
        .then(
      (value) {
        return value.data;
      },
    );
    return responseBody == null ? [] : List<String>.from(responseBody);
  }

  @override
  Future<String> cancelBidTransaction({
    String? receiptAddress,
    String? nftAddress,
  }) {
    return client
        .get(
            '/transaction/cancel-bid?receiptAddress=${receiptAddress ?? ''}&nftAddress=$nftAddress')
        .then((value) => value.data);
  }

  @override
  Future<String?> cancelListingTransaction({
    required String nftAddress,
  }) {
    return client
        .get('/transaction/cancel-listing?nftAddress=$nftAddress')
        .then((value) => value.data);
  }

  @override
  Future<String?> instantBuyTransaction({
    required String mintAccount,
    required int price,
    required String sellerAddress,
    required String buyerAddress,
  }) {
    return client
        .get(
          '/transaction/instant-buy?mintAccount=$mintAccount&price=$price&sellerAddress=$sellerAddress&buyerAddress=$buyerAddress',
        )
        .then((value) => value.data);
  }

  @override
  Future<String?> listTransaction({
    required String sellerAddress,
    required String mintAccount,
    required int price,
    String? printReceipt,
  }) {
    return client
        .get(
          '/transaction/list?sellerAddress=$sellerAddress&mintAccount=$mintAccount&price=$price&printReceipt=$printReceipt',
        )
        .then((value) => value.data);
  }

  @override
  Future<String?> mintOneTransaction({
    required String candyMachineAddress,
    required String minterAddress,
    String? label,
  }) async {
    return await client
        .get(
            '/transaction/mint-one?candyMachineAddress=$candyMachineAddress&minterAddress=$minterAddress&label=$label')
        .then(
          (value) => value.data,
        );
  }

  @override
  Future<String> privateBidTransaction({
    required String buyerAddress,
    required String mintAccount,
    required int price,
    String? sellerAddress,
    String? printReceipt,
  }) {
    return client
        .get(
            '/transaction/private-bid?buyerAddress=$buyerAddress&mintAccount=$mintAccount&price=$price&sellerAddress=${sellerAddress ?? ''}&printReceipt=${printReceipt ?? 'false'}')
        .then((value) => value.data);
  }

  @override
  Future<String> signComicTransaction({
    required String nftAddress,
    required String signerAddress,
  }) {
    return client
        .get(
            '/transaction/sign-comic?nftAddress=$nftAddress&signerAddress=$signerAddress')
        .then((value) => value.data);
  }

  @override
  Future<String> useComicIssueNftTransaction({
    required String nftAddress,
    required String ownerAddress,
  }) async {
    try {
      final transaction = await client
          .get(
            '/transaction/use-comic-issue-nft?nftAddress=$nftAddress&ownerAddress=$ownerAddress',
          )
          .then((value) => value.data);
      return transaction;
    } catch (error, stackTrace) {
      Sentry.captureException(error, stackTrace: stackTrace);
      throw Exception('Failed to get transaction from API');
    }
  }
}
