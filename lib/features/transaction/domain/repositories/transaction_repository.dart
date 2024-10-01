import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class TransactionRepository {
  Future<Either<AppException, List<String>>> mintTransaction({
    required int couponId,
    required int numberOfItems,
    required String candyMachineAddress,
    required String minterAddress,
    String? label,
  });
  Future<Either<AppException, String>> useComicIssueAssetTransaction({
    required String digitalAssetAddress,
    required String ownerAddress,
  });
  Future<Either<AppException, String>> listTransaction({
    required String sellerAddress,
    required String mintAccount,
    required int price,
  });
  Future<Either<AppException, List<String>>> buyMultipleItems(
      Map<String, dynamic> query);
  Future<Either<AppException, String>> cancelListingTransaction({
    required String digitalAssetAddress,
  });

  Future<Either<AppException, String>> sendMintTransaction({
    required String walletAddress,
    required List<String> transactions,
  });
}
