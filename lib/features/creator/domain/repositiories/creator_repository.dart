import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class CreatorRepository {
  Future<Either<AppException, List<CreatorModel>>> getCreators(
      {String? queryString});
  Future<CreatorModel?> getCreator(String slug);
  Future<void> followCreator(String slug);
  Future<Either<AppException, List<CreatorModel>>> getFollowedByUser(
      {required int userId, required String query});
}
