import 'package:d_reader_flutter/features/comic_issue/data/datasource/comic_issue_data_source.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/owned_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/repositories/comic_issue_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/comic_page.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class ComicIssueRepositoryImpl implements ComicIssueRepository {
  final ComicIssueDataSource dataSource;

  ComicIssueRepositoryImpl(this.dataSource);

  @override
  Future<void> favouritiseIssue(int id) {
    return dataSource.favouritiseIssue(id);
  }

  @override
  Future<Either<AppException, ComicIssueModel>> getComicIssue(String id) {
    return dataSource.getComicIssue(id);
  }

  @override
  Future<List<PageModel>> getComicIssuePages(int id) {
    return dataSource.getComicIssuePages(id);
  }

  @override
  Future<Either<AppException, List<ComicIssueModel>>> getComicIssues({
    String? queryString,
  }) {
    return dataSource.getComicIssues(queryString: queryString);
  }

  @override
  Future<Either<AppException, List<OwnedComicIssue>>> getOwnedIssues({
    required int id,
    required String query,
  }) {
    return dataSource.getOwnedIssues(id: id, query: query);
  }

  @override
  Future<void> rateIssue({required int id, required int rating}) {
    return dataSource.rateIssue(id: id, rating: rating);
  }
}
