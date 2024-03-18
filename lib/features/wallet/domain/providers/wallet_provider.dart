import 'package:d_reader_flutter/features/wallet/data/datasource/wallet_remote_source.dart';
import 'package:d_reader_flutter/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:d_reader_flutter/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final walletDataSourceProvider =
    Provider.family<WalletDataSource, NetworkService>(
  (ref, networkService) {
    return WalletRemoteDataSource(networkService);
  },
);

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) {
    final NetworkService networkService = ref.watch(networkServiceProvider);
    final walletDataSource = ref.watch(
      walletDataSourceProvider(networkService),
    );
    return WalletRepositoryImpl(walletDataSource);
  },
);
