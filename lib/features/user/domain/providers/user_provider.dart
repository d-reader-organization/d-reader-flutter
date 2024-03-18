import 'package:d_reader_flutter/features/user/data/datasource/user_remote_data_source.dart';
import 'package:d_reader_flutter/features/user/data/repositories/user_repository_impl.dart';
import 'package:d_reader_flutter/features/user/domain/repositories/user_repository.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userDataSourceProvider = Provider.family<UserDataSource, NetworkService>(
  (ref, networkService) {
    return UserRemoteDataSource(networkService);
  },
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) {
    final NetworkService networkService = ref.watch(networkServiceProvider);

    final UserDataSource dataSource = ref.watch(
      userDataSourceProvider(
        networkService,
      ),
    );
    return UserRepositoryImpl(dataSource);
  },
);
