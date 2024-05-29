import 'package:d_reader_flutter/features/twitter/data/datasource/twitter_remote_data_source.dart';
import 'package:d_reader_flutter/features/twitter/data/repositories/twitter_repository_impl.dart';
import 'package:d_reader_flutter/features/twitter/domain/repositories/twitter_repository.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final twitterDataSourceProvider =
    Provider.family<TwitterDataSource, NetworkService>(
  (ref, networkService) {
    return TwitterRemoteDataSource(networkService);
  },
);

final twitterRepositoryProvider = StateProvider<TwitterRepository>(
  (ref) {
    final networkService = ref.watch(networkServiceProvider);
    final dataSource = ref.watch(twitterDataSourceProvider(networkService));

    return TwitterRepositoryImpl(dataSource);
  },
);
