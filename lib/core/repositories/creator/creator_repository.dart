import 'package:d_reader_flutter/core/models/creator.dart';

abstract class CreatorRepository {
  Future<List<CreatorModel>> getCreators();
  Future<CreatorModel> getCreator(String slug);
}
