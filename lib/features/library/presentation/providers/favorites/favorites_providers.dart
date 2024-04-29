import 'dart:async' show Timer;

import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/comic/domain/providers/comic_provider.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/paginated_per_user_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final favoriteComicsProvider = StateNotifierProvider<
    PaginatedByUserId<ComicModel>, PaginationState<ComicModel>>((ref) {
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
  final fetch = ref.read(comicRepositoryProvider).getFavoriteComics;
  return PaginatedByUserId(
    fetch: fetch,
    userId: ref.watch(environmentProvider).user?.id ?? 0,
  )..init();
});
