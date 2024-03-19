import 'dart:async' show Timer;

import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comics_notifier.g.dart';

@riverpod
class GenericComicNotifier extends _$GenericComicNotifier {
  bool isEnd = false, isLoading = false;
  @override
  FutureOr<List<ComicModel>> build({
    required int userId,
    required Future<Either<AppException, List<ComicModel>>> Function({
      required int userId,
      required String query,
    }) fetch,
  }) async {
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
    final response = await fetch(
      userId: userId,
      query: 'skip=0&take=20',
    );
    return response.fold(
      (exception) => [],
      (data) => data,
    );
  }

  Future<void> fetchNext() async {
    if (isEnd || isLoading) {
      return;
    }
    isLoading = true;
    final newComics = await fetch(
      userId: userId,
      query: 'skip=${state.value?.length ?? 0}&take=20',
    ).then((value) => value.fold(
          (exception) => [],
          (data) => data,
        ));
    if (newComics.isEmpty) {
      isEnd = true;
      return;
    }
    isLoading = false;
    state = AsyncValue.data([...?state.value, ...newComics]);
  }
}
