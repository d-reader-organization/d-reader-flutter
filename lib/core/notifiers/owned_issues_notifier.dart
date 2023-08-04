import 'dart:async' show Timer;

import 'package:d_reader_flutter/core/models/owned_comic_issue.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final ownedIssuesAsyncProvider = AsyncNotifierProvider // TODO change arguments
    .family<OwnedIssuesAsyncNotifier, List<OwnedComicIssue>, String>(
  OwnedIssuesAsyncNotifier.new,
);

class OwnedIssuesAsyncNotifier
    extends FamilyAsyncNotifier<List<OwnedComicIssue>, String> {
  bool isEnd = false, isLoading = false;
  @override
  FutureOr<List<OwnedComicIssue>> build(String arg) async {
    final (userId, queryString) = getArgs();
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
    return await ref.read(ownedIssuesProvider(
      OwnedIssuesArgs(
        userId: userId,
        query: 'skip=0&take=20&$queryString',
      ),
    ).future);
  }

  (int, String) getArgs() {
    final [userId, query] = arg.split('?');
    return (int.parse(userId), query);
  }

  fetchNext() async {
    if (isEnd || isLoading) {
      return;
    }
    isLoading = true;
    final (userId, queryString) = getArgs();
    final newIssues = await ref.read(
      ownedIssuesProvider(
        OwnedIssuesArgs(
          userId: userId,
          query: 'skip=${state.value?.length ?? 0}&take=20&$queryString',
        ),
      ).future,
    );
    if (newIssues.isEmpty) {
      isEnd = true;
      return;
    }
    isLoading = false;
    state = AsyncValue.data([...?state.value, ...newIssues]);
  }
}

class OwnedIssuesArgs {
  final String query;
  final int userId;

  OwnedIssuesArgs({
    required this.userId,
    this.query = 'skip=0&take=20',
  });
}
