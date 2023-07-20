import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/core/models/candy_machine.dart';
import 'package:d_reader_flutter/core/repositories/candy_machine/repository.dart';
import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CandyMachineRepositoryImpl implements CandyMachineRepository {
  final Dio client;

  CandyMachineRepositoryImpl({
    required this.client,
  });

  @override
  Future<CandyMachineModel?> getCandyMachine(String address) async {
    final response = await client
        .get('/candy-machine/get/$address')
        .then((value) => value.data);
    return response == null ? null : CandyMachineModel.fromJson(response);
  }

  @override
  Future<List<Receipt>> getReceipts({String? queryString}) async {
    final response = await client
        .get('/candy-machine/get/receipts?$queryString')
        .then((value) => value.data);

    if (response == null) {
      return [];
    }

    return List<Receipt>.from(
      response.map(
        (item) => Receipt.fromJson(
          item,
        ),
      ),
    );
  }

  @override
  Future<String?> constructNftTransaction(String candyMachineAddress) async {
    return await client
        .get(
            '/candy-machine/transactions/mint-one?candyMachineAddress=$candyMachineAddress')
        .then(
          (value) => value.data,
        );
  }

  @override
  Future<String> useComicIssueNftTransaction(String nftAddress) async {
    try {
      final transaction = await client
          .get(
            '/candy-machine/transactions/use-comic-issue-nft/$nftAddress',
          )
          .then((value) => value.data);
      return transaction;
    } catch (error, stackTrace) {
      Sentry.captureException(error, stackTrace: stackTrace);
      throw Exception('Failed to get transaction from API');
    }
  }
}
