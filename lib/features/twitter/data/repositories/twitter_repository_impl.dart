import 'package:d_reader_flutter/features/twitter/data/datasource/twitter_remote_data_source.dart';
import 'package:d_reader_flutter/features/twitter/domain/repositories/twitter_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class TwitterRepositoryImpl implements TwitterRepository {
  final TwitterDataSource _dataSource;

  TwitterRepositoryImpl(this._dataSource);
  @override
  Future<Either<AppException, String>> assetMintedContent(String assetAddress) {
    return _dataSource.assetMintedContent(assetAddress);
  }
}
