import 'package:d_reader_flutter/features/digital_asset/data/datasource/digital_asset_remote_data_source.dart';
import 'package:d_reader_flutter/features/digital_asset/data/repositories/digital_asset_repository_impl.dart';
import 'package:d_reader_flutter/features/digital_asset/domain/repositories/digital_asset_repository.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final digitalAssetDataSourceProvider =
    Provider.family<DigitalAssetDataSource, NetworkService>(
  (ref, networkService) {
    return DigitalAssetRemoteDataSource(networkService);
  },
);

final digitalAssetRepositoryProvider = Provider<DigitalAssetRepository>(
  (ref) {
    final networkService = ref.watch(networkServiceProvider);
    final dataSource =
        ref.watch(digitalAssetDataSourceProvider(networkService));

    return DigitalAssetRepositoryImpl(dataSource);
  },
);
