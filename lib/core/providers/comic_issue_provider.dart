import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/repositories/comic_issues/comic_issue_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final comicIssuesProvider = FutureProvider<List<ComicIssueModel>>((ref) async {
  ComicIssueRepositoryImpl comicIssueRepository = ComicIssueRepositoryImpl();
  return await comicIssueRepository.getComicIssues();
});

final comicIssueSlugProvider =
    FutureProvider.family<ComicIssueModel?, String>((ref, slug) async {
  ComicIssueRepositoryImpl comicIssueRepository = ComicIssueRepositoryImpl();
  return await comicIssueRepository.getComic(slug);
});

final comicIssuesByComicSlugProvider =
    FutureProvider.family<List<ComicIssueModel>, String>(
        (ref, queryString) async {
  ComicIssueRepositoryImpl comicIssueRepository = ComicIssueRepositoryImpl();
  return await comicIssueRepository.getComicIssues(queryString);
});
