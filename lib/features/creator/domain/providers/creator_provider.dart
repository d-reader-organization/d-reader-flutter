import 'package:d_reader_flutter/features/creator/data/datasource/creator_remote_data_source.dart';
import 'package:d_reader_flutter/features/creator/data/repositories/creator_repository_impl.dart';
import 'package:d_reader_flutter/features/creator/domain/repositiories/creator_repository.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final creatorDataSourceProvider =
    Provider.family<CreatorDataSource, NetworkService>(
  (ref, networkService) {
    return CreatorRemoteDataSource(networkService);
  },
);

final creatorRepositoryProvider = Provider<CreatorRepository>(
  (ref) {
    final networkService = ref.watch(networkServiceProvider);
    final dataSource = ref.watch(creatorDataSourceProvider(networkService));

    return CreatorRepositoryImpl(dataSource);
  },
);
