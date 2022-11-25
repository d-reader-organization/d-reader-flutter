import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/repositories/comic_issues/comic_issue_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final comicIssueProvider = FutureProvider<List<ComicIssueModel>>((ref) async {
  ComicIssueRepositoryImpl comicIssueRepository = ComicIssueRepositoryImpl();
  return await comicIssueRepository.getComicIssues();
});
