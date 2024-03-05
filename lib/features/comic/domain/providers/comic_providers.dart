import 'package:d_reader_flutter/features/comic/data/datasource/comic_remote_source.dart';
import 'package:d_reader_flutter/features/comic/data/repositories/comic_repository_impl.dart';
import 'package:d_reader_flutter/features/comic/domain/repositories/comic_repository.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final comicDataSourceProvider =
    Provider.family<ComicDataSource, NetworkService>(
  (ref, networkService) {
    return ComicRemoteDataSource(networkService);
  },
);

final comicRepositoryProvider = Provider<ComicRepository>(
  (ref) {
    final networkService = ref.watch(networkServiceProvider);
    final dataSource = ref.watch(comicDataSourceProvider(networkService));

    return ComicRepositoryImpl(dataSource);
  },
);
