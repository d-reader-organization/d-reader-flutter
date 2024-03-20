import 'dart:async' show Timer;

import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/features/creator/domain/providers/creator_provider.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/paginated_per_user_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final followedCreatorsProvider = StateNotifierProvider<
    PaginatedByUserId<CreatorModel>, PaginationState<CreatorModel>>((ref) {
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

  final fetch = ref.read(creatorRepositoryProvider).getFollowedByUser;
  return PaginatedByUserId(
    fetch: fetch,
    userId: ref.watch(environmentProvider).user?.id ?? 0,
  )..init();
});

final isDeleteInProgress = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final selectedCreatorSlugs = StateProvider.autoDispose<List<String>>(
  (ref) {
    return [];
  },
);
