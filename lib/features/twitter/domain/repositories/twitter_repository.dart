import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class TwitterRepository {
  Future<Either<AppException, String>> assetMintedContent(String assetAddress);
}
