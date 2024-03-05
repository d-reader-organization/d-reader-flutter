import 'package:d_reader_flutter/features/creator/data/datasource/creator_remote_data_source.dart';
import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/features/creator/domain/repositiories/creator_repository.dart';

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
  Future<List<CreatorModel>> getCreators({String? queryString}) {
    return dataSource.getCreators(queryString: queryString);
  }
}