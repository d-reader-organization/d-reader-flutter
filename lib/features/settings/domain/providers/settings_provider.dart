import 'package:d_reader_flutter/features/settings/data/datasource/settings_remote_source.dart';
import 'package:d_reader_flutter/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:d_reader_flutter/features/settings/domain/repositories/settings_repository.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final settingsDataSourceProvider =
    Provider.family<SettingsRemoteSource, NetworkService>(
  (ref, networkService) {
    return SettingsRemoteDataSource(networkService);
  },
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) {
    final NetworkService networkService = ref.watch(networkServiceProvider);

    final SettingsRemoteSource dataSource = ref.watch(
      settingsDataSourceProvider(
        networkService,
      ),
    );
    return SettingsRepositoryImpl(dataSource);
  },
);
