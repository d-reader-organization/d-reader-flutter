import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/core/models/candy_machine.dart';
import 'package:d_reader_flutter/core/repositories/candy_machine/repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';

class CandyMachineRepositoryImpl implements CandyMachineRepository {
  @override
  Future<CandyMachineModel?> getCandyMachine(String address) async {
    final String? responseBody =
        await ApiService.instance.apiCallGet('/candy-machine/get/$address');
    return responseBody == null
        ? null
        : CandyMachineModel.fromJson(jsonDecode(responseBody));
  }

  @override
  Future<List<Receipt>> getReceipts({String? queryString}) async {
    final String? responseBody = await ApiService.instance
        .apiCallGet('/candy-machine/get/receipts?$queryString');

    if (responseBody == null) {
      return [];
    }
    Iterable decodedData = jsonDecode(responseBody);
    return List<Receipt>.from(
      decodedData.map(
        (item) => Receipt.fromJson(
          item,
        ),
      ),
    );
  }

  @override
  Future<String?> constructNftTransaction(String candyMachineAddress) async {
    return await ApiService.instance.apiCallGet(
        '/candy-machine/transactions/construct/mint-one?candyMachineAddress=$candyMachineAddress');
  }
}
