import 'dart:async' show Timer;

import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/notifiers/owned_comics_notifier.dart';
import 'package:d_reader_flutter/core/notifiers/pagination_notifier.dart';
import 'package:d_reader_flutter/core/providers/dio_provider.dart';
import 'package:d_reader_flutter/core/repositories/comic/comic_repository_impl.dart';
import 'package:d_reader_flutter/core/states/pagination_state.dart';
import 'package:d_reader_flutter/ui/utils/append_default_query_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final comicRepositoryProvider = Provider<ComicRepositoryImpl>(
  (ref) {
    return ComicRepositoryImpl(
      client: ref.watch(dioProvider),
    );
  },
);

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
    return ref.read(comicRepositoryProvider).getComics(
        queryString: queryString != null && queryString.isNotEmpty
            ? queryString
            : appendDefaultQuery(queryString));
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
  return ref.read(comicRepositoryProvider).getComic(slug);
});

final updateComicFavouriteProvider =
    FutureProvider.autoDispose.family<void, String>((ref, slug) {
  ref.read(comicRepositoryProvider).updateComicFavourite(slug);
});

final rateComicProvider = FutureProvider.autoDispose.family<dynamic, dynamic>(
  (ref, input) async {
    if (input['slug'] != null) {
      final result = await ref.read(comicRepositoryProvider).rateComic(
            slug: input['slug'],
            rating: input['rating'],
          );
      return result;
    }
  },
);

final ownedComicsProvider =
    FutureProvider.autoDispose.family<List<ComicModel>, OwnedComicsArgs>(
  (ref, arg) {
    return ref
        .read(comicRepositoryProvider)
        .getOwnedComics(walletAddress: arg.walletAddress, query: arg.query);
  },
);
