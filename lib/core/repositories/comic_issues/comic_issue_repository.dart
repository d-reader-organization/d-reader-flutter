import 'package:d_reader_flutter/core/models/comic_issue.dart';

abstract class ComicIssueRepository {
  Future<List<ComicIssueModel>> getComicIssues();
}
