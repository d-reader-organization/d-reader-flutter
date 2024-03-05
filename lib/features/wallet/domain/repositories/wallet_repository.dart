import 'package:d_reader_flutter/features/wallet/domain/models/wallet.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class WalletRepository {
  Future<Either<AppException, bool>> syncWallet(String address);
  Future<Either<AppException, WalletModel>> updateWallet({
    required String address,
    required String label,
  });
}
