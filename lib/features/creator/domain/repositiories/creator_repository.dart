import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';

abstract class CreatorRepository {
  Future<List<CreatorModel>> getCreators({String? queryString});
  Future<CreatorModel?> getCreator(String slug);
  Future<void> followCreator(String slug);
}
