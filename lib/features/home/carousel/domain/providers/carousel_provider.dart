import 'package:d_reader_flutter/features/home/carousel/data/datasource/carousel_remote_data_soruce.dart';
import 'package:d_reader_flutter/features/home/carousel/data/repositories/carousel_repository_impl.dart';
import 'package:d_reader_flutter/features/home/carousel/domain/repositories/carousel_repository.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final carouselDataSourceProvider =
    Provider.family<CarouselDataSource, NetworkService>(
  (ref, networkService) {
    return CarouselRemoteDataSource(networkService);
  },
);

final carouselRepositoryProvider = Provider<CarouselRepository>(
  (ref) {
    final networkService = ref.watch(networkServiceProvider);
    final dataSource = ref.watch(carouselDataSourceProvider(networkService));

    return CarouselRepositoryImpl(dataSource);
  },
);
