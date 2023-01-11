import 'package:d_reader_flutter/core/repositories/playground/playground_repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';
import 'package:d_reader_flutter/ioc.dart';

class PlaygroundRepositoryImpl implements PlaygroundRepository {
  @override
  Future<String?> constructNftTransaction() async {
    return await IoCContainer.resolveContainer<ApiService>()
        .apiCallGet('/playground/transactions/construct/create-nft');
  }
}
