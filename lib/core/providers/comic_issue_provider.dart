import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/page_model.dart';
import 'package:d_reader_flutter/core/repositories/comic_issues/comic_issue_repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:d_reader_flutter/ui/utils/append_default_query_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final comicIssuesProvider =
    FutureProvider.family<List<ComicIssueModel>, String?>(
        (ref, queryString) async {
  return await IoCContainer.resolveContainer<ComicIssueRepositoryImpl>()
      .getComicIssues(appendDefaultQuery(queryString));
});

final comicIssueDetailsProvider =
    FutureProvider.family<ComicIssueModel?, int>((ref, id) async {
  return await IoCContainer.resolveContainer<ComicIssueRepositoryImpl>()
      .getComicIssue(id);
});

final comicIssuePagesProvider =
    FutureProvider.family<List<PageModel>, int>((ref, id) async {
  return await IoCContainer.resolveContainer<ComicIssueRepositoryImpl>()
      .getComicIssuePages(id);
});

final favouriteComicIssueProvider = FutureProvider.family<void, int>(
  (ref, id) {
    return IoCContainer.resolveContainer<ComicIssueRepositoryImpl>()
        .favouritiseIssue(id);
  },
);

class ComicIssueDetailState {
  const ComicIssueDetailState({
    required this.selectedNftsCount,
  });
  final int selectedNftsCount;

  ComicIssueDetailState copyWith({required int selectedNftsCount}) {
    return ComicIssueDetailState(selectedNftsCount: selectedNftsCount);
  }
}
