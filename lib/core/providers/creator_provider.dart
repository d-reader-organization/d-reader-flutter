import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/notifiers/pagination_notifier.dart';
import 'package:d_reader_flutter/core/repositories/creator/creator_repository_impl.dart';
import 'package:d_reader_flutter/core/states/pagination_state.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:d_reader_flutter/ui/utils/append_default_query_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final creatorsProvider = FutureProvider.family<List<CreatorModel>, String?>(
    (ref, queryString) async {
  return await IoCContainer.resolveContainer<CreatorRepositoryImpl>()
      .getCreators(queryString: queryString ?? appendDefaultQuery(queryString));
});

final creatorProvider =
    FutureProvider.family<CreatorModel, String>((ref, slug) async {
  return await IoCContainer.resolveContainer<CreatorRepositoryImpl>()
      .getCreator(slug);
});

final followCreatorProvider =
    FutureProvider.family<bool, String>((ref, slug) async {
  return await IoCContainer.resolveContainer<CreatorRepositoryImpl>()
      .followCreator(slug);
});

final paginatedCreatorsProvider = StateNotifierProvider.autoDispose.family<
    PaginationNotifier<CreatorModel>,
    PaginationState<CreatorModel>,
    String?>((ref, query) {
  final fetch =
      IoCContainer.resolveContainer<CreatorRepositoryImpl>().getCreators;
  return PaginationNotifier<CreatorModel>(
    fetch: fetch,
    query: query,
  )..init();
});
