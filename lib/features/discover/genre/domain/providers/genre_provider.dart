import 'package:d_reader_flutter/features/discover/genre/data/datasource/genre_remote_data_source.dart';
import 'package:d_reader_flutter/features/discover/genre/data/repositories/genre_repository_impl.dart';
import 'package:d_reader_flutter/features/discover/genre/domain/repositories/genre_repository.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final genreDataSourceProvider =
    Provider.family<GenreDataSource, NetworkService>(
  (ref, networkService) {
    return GenreRemoteDataSource(networkService);
  },
);

final genreRepositoryProvider = Provider<GenreRepository>(
  (ref) {
    final networkService = ref.watch(networkServiceProvider);
    final dataSource = ref.watch(genreDataSourceProvider(networkService));

    return GenreRepositoryImpl(dataSource);
  },
);
