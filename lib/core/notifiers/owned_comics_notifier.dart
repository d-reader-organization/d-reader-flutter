import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final ownedComicsAsyncProvider = AsyncNotifierProvider.autoDispose
    .family<OwnedComicsAsyncNotifier, List<ComicModel>, OwnedComicsArgs>(
  OwnedComicsAsyncNotifier.new,
);

class OwnedComicsAsyncNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<ComicModel>, OwnedComicsArgs> {
  bool isEnd = false, isLoading = false;
  @override
  FutureOr<List<ComicModel>> build(OwnedComicsArgs arg) async {
    return await ref.read(ownedComicsProvider(arg).future);
  }

  fetchNext() async {
    if (isEnd || isLoading) {
      return;
    }
    isLoading = true;
    final newComics = await ref.read(
      ownedComicsProvider(
        OwnedComicsArgs(
          walletAddress: arg.walletAddress,
          query: 'skip=${state.value?.length ?? 0}&take=20',
        ),
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

class OwnedComicsArgs {
  final String walletAddress, query;

  OwnedComicsArgs({
    required this.walletAddress,
    this.query = 'skip=0&take=20',
  });
}
