import 'package:d_reader_flutter/features/nft/data/datasource/nft_remote_data_source.dart';
import 'package:d_reader_flutter/features/nft/data/repositories/nft_repository_impl.dart';
import 'package:d_reader_flutter/features/nft/domain/repositories/nft_repository.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final nftDataSourceProvider = Provider.family<NftDataSource, NetworkService>(
  (ref, networkService) {
    return NftRemoteDataSource(networkService);
  },
);

final nftRepositoryProvider = Provider<NftRepository>(
  (ref) {
    final networkService = ref.watch(networkServiceProvider);
    final dataSource = ref.watch(nftDataSourceProvider(networkService));

    return NftRepositoryImpl(dataSource);
  },
);
