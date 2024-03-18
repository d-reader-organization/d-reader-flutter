import 'package:d_reader_flutter/features/wallet/data/datasource/wallet_remote_source.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet.dart';
import 'package:d_reader_flutter/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletDataSource walletDataSource;

  WalletRepositoryImpl(this.walletDataSource);

  @override
  Future<Either<AppException, bool>> syncWallet(String address) {
    return walletDataSource.syncWallet(address);
  }

  @override
  Future<Either<AppException, WalletModel>> updateWallet({
    required String address,
    required String label,
  }) {
    return walletDataSource.updateWallet(address: address, label: label);
  }
}
