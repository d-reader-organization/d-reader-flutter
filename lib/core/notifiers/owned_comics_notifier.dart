import 'dart:async' show Timer;

import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final ownedComicsAsyncProvider = AsyncNotifierProvider.family<
    OwnedComicsAsyncNotifier, List<ComicModel>, int>(
  OwnedComicsAsyncNotifier.new,
);

class OwnedComicsAsyncNotifier
    extends FamilyAsyncNotifier<List<ComicModel>, int> {
  bool isEnd = false, isLoading = false;
  @override
  FutureOr<List<ComicModel>> build(int arg) async {
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

    return await ref.read(ownedComicsProvider(
      userId: arg,
      query: 'skip=0&take=20',
    ).future);
  }

  fetchNext() async {
    if (isEnd || isLoading) {
      return;
    }
    isLoading = true;
    final newComics = await ref.read(
      ownedComicsProvider(
        userId: arg,
        query: 'skip=${state.value?.length ?? 0}&take=20',
      ).future,
    );
    if (newComics.isEmpty) {
      isEnd = true;
      return;
    }
    isLoading = false;
    state = AsyncValue.data([...?state.value, ...newComics]);
  }
}
