import 'package:d_reader_flutter/features/authentication/data/datasource/auth_remote_source.dart';
import 'package:d_reader_flutter/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:d_reader_flutter/features/authentication/domain/repositories/auth_repository.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authDataSourceProvider = Provider.family<AuthDataSource, NetworkService>(
  (ref, networkService) {
    return AuthRemoteDataSource(networkService);
  },
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) {
    final NetworkService networkService = ref.watch(networkServiceProvider);
    final AuthDataSource dataSource =
        ref.watch(authDataSourceProvider(networkService));
    return AuthRepositoryImpl(dataSource);
  },
);
