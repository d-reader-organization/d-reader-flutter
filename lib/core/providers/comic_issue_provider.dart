import 'dart:async' show Timer;

import 'package:d_reader_flutter/constants/constants.dart';

import 'package:d_reader_flutter/core/providers/dio/dio_provider.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/owned_issue.dart';
import 'package:d_reader_flutter/shared/domain/models/comic_page.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/domain/providers/pagination_notifier.dart';
import 'package:d_reader_flutter/ui/utils/append_default_query_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'comic_issue_provider.g.dart';

final comicIssueRepository = Provider<ComicIssueRepositoryImpl>(
  (ref) {
    return ComicIssueRepositoryImpl(
      client: ref.watch(dioProvider),
    );
  },
);

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

final comicIssueDetailsProvider =
    FutureProvider.autoDispose.family<ComicIssueModel?, int>((ref, id) {
  return ref.read(comicIssueRepository).getComicIssue(id);
});

final comicIssuePagesProvider =
    FutureProvider.autoDispose.family<List<PageModel>, int>((ref, id) async {
  return ref.read(comicIssueRepository).getComicIssuePages(id);
});

final rateComicIssueProvider =
    FutureProvider.autoDispose.family<dynamic, dynamic>(
  (ref, input) async {
    if (input['id'] != null) {
      await ref.read(comicIssueRepository).rateIssue(
            id: input['id'],
            rating: input['rating'],
          );
    }
  },
);

final favouritiseComicIssueProvider =
    FutureProvider.autoDispose.family<void, int>((ref, id) {
  return ref.read(comicIssueRepository).favouritiseIssue(id);
});

final paginatedIssuesProvider = StateNotifierProvider.family<
    PaginationNotifier<ComicIssueModel>,
    PaginationState<ComicIssueModel>,
    String?>((ref, query) {
  final fetch = ref.read(comicIssueRepository).getComicIssues;
  return PaginationNotifier<ComicIssueModel>(
    fetch: fetch,
    query: query,
  )..init();
});

@riverpod
Future<List<OwnedComicIssue>> ownedIssues(Ref ref,
    {required int userId, required String query}) {
  return ref
      .read(comicIssueRepository)
      .getOwnedIssues(id: userId, query: query);
}

final lastSelectedTabIndex = StateProvider<int>((ref) {
  final int? lastIndex = LocalStore.instance.get(issueLastSelectedTabKey);
  return lastIndex ?? 0;
});
