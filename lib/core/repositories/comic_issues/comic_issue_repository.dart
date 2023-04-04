import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/page_model.dart';

abstract class ComicIssueRepository {
  Future<List<ComicIssueModel>> getComicIssues({String? queryString});
  Future<ComicIssueModel?> getComicIssue(int id);
  Future<List<PageModel>> getComicIssuePages(int id);
  Future<void> favouritiseIssue(int id);
}
