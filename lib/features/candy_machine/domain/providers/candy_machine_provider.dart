import 'package:d_reader_flutter/features/candy_machine/data/datasource/candy_machine_remote_source.dart';
import 'package:d_reader_flutter/features/candy_machine/data/repositories/candy_machine_repository_impl.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/repositories/candy_machine_repository.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final candyMachineDataSourceProvider =
    Provider.family<CandyMachineDataSource, NetworkService>(
  (ref, networkService) {
    return CandyMachineRemoteDataSource(networkService);
  },
);

final candyMachineRepositoryProvider = Provider<CandyMachineRepository>(
  (ref) {
    final NetworkService networkService = ref.watch(networkServiceProvider);

    final CandyMachineDataSource dataSource = ref.watch(
      candyMachineDataSourceProvider(
        networkService,
      ),
    );
    return CandyMachineRepositoryImpl(dataSource);
  },
);
