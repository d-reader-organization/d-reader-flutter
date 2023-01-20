import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/repositories/comic_issues/comic_issue_repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final comicIssuesProvider =
    FutureProvider.family<List<ComicIssueModel>, String>(
        (ref, queryString) async {
  return await IoCContainer.resolveContainer<ComicIssueRepositoryImpl>()
      .getComicIssues(queryString);
});

final comicIssueDetailsProvider =
    FutureProvider.family<ComicIssueModel?, int>((ref, id) async {
  return await IoCContainer.resolveContainer<ComicIssueRepositoryImpl>()
      .getComic(id);
});

class ComicIssueDetailState {
  const ComicIssueDetailState({
    required this.selectedNftsCount,
  });
  final int selectedNftsCount;

  ComicIssueDetailState copyWith({required int selectedNftsCount}) {
    return ComicIssueDetailState(selectedNftsCount: selectedNftsCount);
  }
}

final comicIssueStateNotifier =
    StateNotifierProvider<ComicIssueDetailNotifier, ComicIssueDetailState>(
        (ref) => ComicIssueDetailNotifier());

class ComicIssueDetailNotifier extends StateNotifier<ComicIssueDetailState> {
  ComicIssueDetailNotifier()
      : super(const ComicIssueDetailState(selectedNftsCount: 0));

  update(bool isIncrement) async {
    state = state.copyWith(
      selectedNftsCount: isIncrement
          ? state.selectedNftsCount + 1
          : state.selectedNftsCount - 1,
    );
  }
}
