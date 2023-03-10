import 'package:d_reader_flutter/core/repositories/auction_house/repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';
import 'package:d_reader_flutter/ioc.dart';

class AuctionHouseRepositoryImpl implements AuctionHouseRepository {
  @override
  Future<String?> listItem({
    required String mintAccount,
    required double price,
    String? printReceipt,
  }) {
    return IoCContainer.resolveContainer<ApiService>().apiCallGet(
        '/auction-house/transactions/construct/list?mintAccount=$mintAccount&price=$price&printReceipt=$printReceipt');
  }
}
