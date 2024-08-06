import 'dart:async' show Timer;

import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/owned_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:d_reader_flutter/shared/domain/models/comic_page.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/domain/providers/pagination_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comic_issue_providers.g.dart';

@riverpod
Future<ComicIssueModel> comicIssueDetails(
    ComicIssueDetailsRef ref, String id) async {
  final response =
      await ref.read(comicIssueRepositoryProvider).getComicIssue(id);
  return response.fold((exception) {
    throw exception;
  }, (comicIssue) => comicIssue);
}

@riverpod
Future<List<OwnedComicIssue>> ownedIssues(Ref ref,
    {required int userId, required String query}) async {
  final response = await ref
      .read(comicIssueRepositoryProvider)
      .getOwnedIssues(id: userId, query: query);

  return response.fold((exception) => [], (result) => result);
}

final comicIssuesProvider =
    FutureProvider.family<List<ComicIssueModel>, String?>(
  (ref, queryString) async {
    Timer? timer;

    ref.onDispose(() {
      timer?.cancel();
    });
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: paginatedDataCacheInSeconds), () {
        ref.invalidateSelf();
      });
    });

    ref.onResume(() {
      timer?.cancel();
    });

    final response = await ref
        .read(comicIssueRepositoryProvider)
        .getComicIssues(queryString: queryString);

    return response.fold((exception) {
      return [];
    }, (result) => result);
  },
);

final paginatedIssuesProvider = StateNotifierProvider.family<
    PaginationNotifier<ComicIssueModel>,
    PaginationState<ComicIssueModel>,
    String?>((ref, query) {
  final fetch = ref.read(comicIssueRepositoryProvider).getComicIssues;
  return PaginationNotifier<ComicIssueModel>(
    fetch: fetch,
    query: query,
  )..init();
});

final comicIssuePagesProvider =
    FutureProvider.autoDispose.family<List<PageModel>, int>((ref, id) async {
  return ref.read(comicIssueRepositoryProvider).getComicIssuePages(id);
});

final lastSelectedTabIndex = StateProvider<int>((ref) {
  final int? lastIndex = LocalStore.instance.get(issueLastSelectedTabKey);
  return lastIndex ?? 0;
});
