import 'package:d_reader_flutter/features/auction_house/data/datasource/auction_house_remote_source.dart';
import 'package:d_reader_flutter/features/auction_house/data/repositories/auction_house_repository_impl.dart';
import 'package:d_reader_flutter/features/auction_house/domain/repositories/auction_house_repository.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final auctionHouseDataSourceProvider =
    Provider.family<AuctionHouseDataSource, NetworkService>(
  (ref, networkService) {
    return AuctionHouseRemoteDataSource(networkService);
  },
);

final auctionHouseRepositoryProvider = Provider<AuctionHouseRepository>(
  (ref) {
    final NetworkService networkService = ref.watch(networkServiceProvider);

    final AuctionHouseDataSource dataSource = ref.watch(
      auctionHouseDataSourceProvider(
        networkService,
      ),
    );
    return AuctionHouseRepositoryImpl(dataSource);
  },
);
