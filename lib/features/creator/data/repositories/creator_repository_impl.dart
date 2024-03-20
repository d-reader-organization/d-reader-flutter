import 'package:d_reader_flutter/features/creator/data/datasource/creator_remote_data_source.dart';
import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/features/creator/domain/repositiories/creator_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class CreatorRepositoryImpl implements CreatorRepository {
  final CreatorDataSource dataSource;

  CreatorRepositoryImpl(this.dataSource);

  @override
  Future<void> followCreator(String slug) {
    return dataSource.followCreator(slug);
  }

  @override
  Future<CreatorModel?> getCreator(String slug) {
    return dataSource.getCreator(slug);
  }

  @override
  Future<Either<AppException, List<CreatorModel>>> getCreators(
      {String? queryString}) {
    return dataSource.getCreators(queryString: queryString);
  }

  @override
  Future<Either<AppException, List<CreatorModel>>> getFollowedByUser(
      {required int userId, required String queryString}) {
    return dataSource.getFollowedByUser(
        userId: userId, queryString: queryString);
  }
}
