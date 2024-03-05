import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/receipt.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class CandyMachineDataSource {
  Future<Either<AppException, CandyMachineModel?>> getCandyMachine({
    required String query,
  });
  Future<Either<AppException, List<Receipt>>> getReceipts({
    String? queryString,
  });
}

class CandyMachineRemoteDataSource implements CandyMachineDataSource {
  final NetworkService networkService;

  CandyMachineRemoteDataSource(this.networkService);

  @override
  Future<Either<AppException, CandyMachineModel?>> getCandyMachine(
      {required String query}) {
    // TODO: implement getCandyMachine
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<Receipt>>> getReceipts(
      {String? queryString}) {
    // TODO: implement getReceipts
    throw UnimplementedError();
  }
}

//   @override
//   Future<List<Receipt>> getReceipts({String? queryString}) async {
//     final response = await client
//         .get('/candy-machine/get/receipts?$queryString')
//         .then((value) => value.data);

//     if (response == null) {
//       return [];
//     }

//     return List<Receipt>.from(
//       response.map(
//         (item) => Receipt.fromJson(
//           item,
//         ),
//       ),
//     );
//   }

//   @override
//   Future<CandyMachineModel?> getCandyMachine({
//     required String query,
//   }) async {
//     final response = await client
//         .get('/candy-machine/get?$query')
//         .then((value) => value.data);
//     return response != null ? CandyMachineModel.fromJson(response) : null;
//   }
// }
