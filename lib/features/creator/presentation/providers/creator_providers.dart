import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/features/creator/domain/providers/creator_provider.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/creators/creators_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/domain/providers/pagination_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final creatorsProvider = FutureProvider.autoDispose
    .family<List<CreatorModel>, String?>((ref, queryString) async {
  final response = await ref
      .read(creatorRepositoryProvider)
      .getCreators(queryString: queryString);

  return response.fold(
    (exception) {
      return [];
    },
    (result) => result,
  );
});

final creatorProvider =
    FutureProvider.autoDispose.family<CreatorModel?, String>((ref, slug) async {
  return await ref.read(creatorRepositoryProvider).getCreator(slug);
});

final paginatedCreatorsProvider = StateNotifierProvider.family<
    PaginationNotifier<CreatorModel>,
    PaginationState<CreatorModel>,
    String?>((ref, query) {
  final fetch = ref.read(creatorRepositoryProvider).getCreators;
  return PaginationNotifier<CreatorModel>(
    fetch: fetch,
    query: query,
  )..init();
});

final unfollowCreatorsProvider =
    FutureProvider.autoDispose.family<bool, List<String>>(
  (ref, creatorSlugs) async {
    await Future.wait(creatorSlugs.map(
      (slug) => ref.read(creatorRepositoryProvider).followCreator(
            slug,
          ),
    ));
    ref.invalidate(followedCreatorsProvider);
    ref.invalidate(selectedCreatorSlugs);
    ref.invalidate(isDeleteInProgress);
    return true;
  },
);
