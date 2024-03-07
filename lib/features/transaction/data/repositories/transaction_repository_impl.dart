import 'package:d_reader_flutter/features/transaction/data/datasource/transaction_remote_data_source.dart';
import 'package:d_reader_flutter/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDataSource dataSource;

  TransactionRepositoryImpl(this.dataSource);

  @override
  Future<Either<AppException, List<String>>> buyMultipleItems(
    Map<String, dynamic> query,
  ) {
    return dataSource.buyMultipleItems(query);
  }

  @override
  Future<Either<AppException, String>> cancelListingTransaction({
    required String nftAddress,
  }) {
    return dataSource.cancelListingTransaction(nftAddress: nftAddress);
  }

  @override
  Future<Either<AppException, String>> listTransaction({
    required String sellerAddress,
    required String mintAccount,
    required int price,
    String? printReceipt,
  }) {
    return dataSource.listTransaction(
        sellerAddress: sellerAddress, mintAccount: mintAccount, price: price);
  }

  @override
  Future<Either<AppException, List<String>>> mintOneTransaction({
    required String candyMachineAddress,
    required String minterAddress,
    String? label,
  }) {
    return dataSource.mintOneTransaction(
        candyMachineAddress: candyMachineAddress, minterAddress: minterAddress);
  }

  @override
  Future<Either<AppException, String>> useComicIssueNftTransaction({
    required String nftAddress,
    required String ownerAddress,
  }) {
    return dataSource.useComicIssueNftTransaction(
        nftAddress: nftAddress, ownerAddress: ownerAddress);
  }
}
