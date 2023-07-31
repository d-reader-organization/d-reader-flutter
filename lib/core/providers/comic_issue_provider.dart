import 'dart:async' show Timer;

import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/owned_comic_issue.dart';
import 'package:d_reader_flutter/core/models/page_model.dart';
import 'package:d_reader_flutter/core/notifiers/owned_issues_notifier.dart';
import 'package:d_reader_flutter/core/notifiers/pagination_notifier.dart';
import 'package:d_reader_flutter/core/providers/dio_provider.dart';
import 'package:d_reader_flutter/core/repositories/comic_issues/comic_issue_repository_impl.dart';
import 'package:d_reader_flutter/core/states/pagination_state.dart';
import 'package:d_reader_flutter/ui/utils/append_default_query_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      final result = await ref.read(comicIssueRepository).rateIssue(
            id: input['id'],
            rating: input['rating'],
          );

      return result;
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

final ownedIssuesProvider =
    FutureProvider.autoDispose.family<List<OwnedComicIssue>, OwnedIssuesArgs>(
  (ref, arg) {
    return ref
        .read(comicIssueRepository)
        .getOwnedIssues(walletAddress: arg.walletAddress, query: arg.query);
  },
);
