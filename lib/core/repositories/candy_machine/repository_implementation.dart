import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/core/models/candy_machine.dart';
import 'package:d_reader_flutter/core/repositories/candy_machine/repository.dart';
import 'package:dio/dio.dart';

class CandyMachineRepositoryImpl implements CandyMachineRepository {
  final Dio client;

  CandyMachineRepositoryImpl({
    required this.client,
  });

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
  Future<CandyMachineModel?> getCandyMachine({
    required String query,
  }) async {
    final response = await client
        .get('/candy-machine/get?$query')
        .then((value) => value.data);
    return response != null ? CandyMachineModel.fromJson(response) : null;
  }
}
