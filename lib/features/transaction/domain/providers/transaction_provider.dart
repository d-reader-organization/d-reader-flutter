import 'package:d_reader_flutter/features/transaction/data/datasource/transaction_remote_data_source.dart';
import 'package:d_reader_flutter/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:d_reader_flutter/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final transactionDataSourceProvider =
    Provider.family<TransactionDataSource, NetworkService>(
  (ref, networkService) {
    return TransactionRemoteDataSource(networkService);
  },
);

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) {
    final networkService = ref.watch(networkServiceProvider);
    final dataSource = ref.watch(transactionDataSourceProvider(networkService));
    return TransactionRepositoryImpl(dataSource);
  },
);
