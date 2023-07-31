import 'dart:async' show Timer;

import 'package:d_reader_flutter/core/models/owned_comic_issue.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final ownedIssuesAsyncProvider = AsyncNotifierProvider.family<
    OwnedIssuesAsyncNotifier, List<OwnedComicIssue>, String>(
  OwnedIssuesAsyncNotifier.new,
);

class OwnedIssuesAsyncNotifier
    extends FamilyAsyncNotifier<List<OwnedComicIssue>, String> {
  bool isEnd = false, isLoading = false;
  @override
  FutureOr<List<OwnedComicIssue>> build(String arg) async {
    final (walletAddress, queryString) = getArgs();
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
        walletAddress: walletAddress,
        query: 'skip=0&take=20&$queryString',
      ),
    ).future);
  }

  (String, String) getArgs() {
    final [walletAddress, query] = arg.split('?');
    return (walletAddress, query);
  }

  fetchNext() async {
    if (isEnd || isLoading) {
      return;
    }
    isLoading = true;
    final (walletAddress, queryString) = getArgs();
    final newIssues = await ref.read(
      ownedIssuesProvider(
        OwnedIssuesArgs(
          walletAddress: walletAddress,
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
  final String walletAddress, query;

  OwnedIssuesArgs({
    required this.walletAddress,
    this.query = 'skip=0&take=20',
  });
}
