import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/providers/comic_issue_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comic_issue_providers.g.dart';

@riverpod
Future<ComicIssueModel> comicIssueDetails(
    ComicIssueDetailsRef ref, int id) async {
  final response =
      await ref.read(comicIssueRepositoryProvider).getComicIssue(id);
  return response.fold((exception) {
    throw exception;
  }, (comicIssue) => comicIssue);
}

final comicIssuesProvider =
    FutureProvider.family<List<ComicIssueModel>, String?>(
        (ref, queryString) async {
  Timer? timer;

  ref.onDispose(() {
    timer?.cancel();
  });
  ref.onCancel(() {
    timer = Timer(const Duration(seconds: 30), () {
      ref.invalidateSelf();
    });
  });

  ref.onResume(() {
    timer?.cancel();
  });

  return ref.read(comicIssueRepository).getComicIssues(
        queryString: queryString ??
            appendDefaultQuery(
              queryString,
            ),
      );
});
