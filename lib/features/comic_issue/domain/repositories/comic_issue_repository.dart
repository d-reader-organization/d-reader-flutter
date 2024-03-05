import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/owned_issue.dart';
import 'package:d_reader_flutter/shared/domain/models/comic_page.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class ComicIssueRepository {
  Either<AppException, List<ComicIssueModel>> getComicIssues(
      {String? queryString});
  Either<AppException, ComicIssueModel?> getComicIssue(int id);
  Future<List<PageModel>> getComicIssuePages(int id);
  Future<void> favouritiseIssue(int id);
  Future<void> rateIssue({
    required int id,
    required int rating,
  });
  Future<List<OwnedComicIssue>> getOwnedIssues({
    required int id,
    required String query,
  });
}
