import 'dart:async' show Timer;

import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/comic/domain/providers/comic_provider.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/domain/providers/pagination_notifier.dart';
import 'package:d_reader_flutter/ui/utils/append_default_query_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'comic_providers.g.dart';

final comicsProvider = FutureProvider.family<List<ComicModel>, String?>(
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
    return ref
        .read(comicRepositoryProvider)
        .getComics(
            queryString: queryString != null && queryString.isNotEmpty
                ? queryString
                : appendDefaultQuery(queryString))
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
  return ref
      .read(comicRepositoryProvider)
      .getComic(slug)
      .then((result) => result.fold((exception) => null, (data) => data));
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

@riverpod
Future<List<ComicModel>> ownedComics(
  Ref ref, {
  required int userId,
  required String query,
}) {
  return ref
      .read(comicRepositoryProvider)
      .getOwnedComics(userId: userId, query: query)
      .then((result) => result.fold(
            (exception) {
              return [];
            },
            (data) {
              return data;
            },
          ));
}

final comicViewModeProvider = StateProvider.autoDispose<ViewMode>(
  (ref) {
    return ViewMode.detailed;
  },
);
