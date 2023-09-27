import 'package:d_reader_flutter/core/models/candy_machine_group.dart';
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
  Future<List<CandyMachineGroupModel>> getGroups(
      {required String query}) async {
    final response = await client
        .get('/candy-machine/get/groups?$query')
        .then((value) => value.data);
    return response != null
        ? List<CandyMachineGroupModel>.from(
            response.map(
              (item) => CandyMachineGroupModel.fromJson(
                item,
              ),
            ),
          )
        : [];
  }
}
