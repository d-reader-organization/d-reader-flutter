import 'dart:async' show Timer;

import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/comic/domain/providers/comic_provider.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/domain/providers/pagination_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final comicsProvider = FutureProvider.family<List<ComicModel>, String?>(
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
    return ref
        .read(comicRepositoryProvider)
        .getComics(queryString: queryString)
        .then((result) => result.fold((exception) {
              // TODO think about
              return [];
            }, (data) => data));
  },
);

final paginatedComicsProvider = StateNotifierProvider.family<
    PaginationNotifier<ComicModel>,
    PaginationState<ComicModel>,
    String?>((ref, query) {
  final fetch = ref.read(comicRepositoryProvider).getComics;
  return PaginationNotifier<ComicModel>(
    fetch: fetch,
    query: query,
  )..init();
});

final comicSlugProvider =
    FutureProvider.autoDispose.family<ComicModel?, String>((ref, slug) async {
  return ref.read(comicRepositoryProvider).getComic(slug).then(
      (result) => result.fold((exception) => throw exception, (data) => data));
});

final updateComicFavouriteProvider =
    FutureProvider.autoDispose.family<void, String>((ref, slug) {
  ref.read(comicRepositoryProvider).updateComicFavourite(slug);
});

final rateComicProvider = FutureProvider.autoDispose.family<dynamic, dynamic>(
  (ref, input) async {
    if (input['slug'] != null) {
      await ref.read(comicRepositoryProvider).rateComic(
            slug: input['slug'],
            rating: input['rating'],
          );
    }
  },
);

final comicViewModeProvider = StateProvider.autoDispose<ViewMode>(
  (ref) {
    return ViewMode.detailed;
  },
);
