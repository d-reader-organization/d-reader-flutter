import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/core/models/candy_machine.dart';
import 'package:d_reader_flutter/core/repositories/candy_machine/candy_machine_repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';
import 'package:d_reader_flutter/ioc.dart';

class CandyMachineRepositoryImpl implements CandyMachineRepository {
  @override
  Future<CandyMachineModel?> getCandyMachine(String address) async {
    final String? responseBody =
        await IoCContainer.resolveContainer<ApiService>()
            .apiCallGet('/candy-machine/get/$address');
    return responseBody == null
        ? null
        : CandyMachineModel.fromJson(jsonDecode(responseBody));
  }

  @override
  Future<List<Receipt>> getReceipts({String? queryString}) async {
    final String? responseBody =
        await IoCContainer.resolveContainer<ApiService>()
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
}
