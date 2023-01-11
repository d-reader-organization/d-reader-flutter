import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/repositories/comic_issues/comic_issue_repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final comicIssuesProvider = FutureProvider<List<ComicIssueModel>>((ref) async {
  return await IoCContainer.resolveContainer<ComicIssueRepositoryImpl>()
      .getComicIssues();
});

final comicIssueDetailsProvider =
    FutureProvider.family<ComicIssueModel?, int>((ref, id) async {
  return await IoCContainer.resolveContainer<ComicIssueRepositoryImpl>()
      .getComic(id);
});

final comicIssuesByQueryParam =
    FutureProvider.family<List<ComicIssueModel>, String>(
        (ref, queryString) async {
  return await IoCContainer.resolveContainer<ComicIssueRepositoryImpl>()
      .getComicIssues(queryString);
});
