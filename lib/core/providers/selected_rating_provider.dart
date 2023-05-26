import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedRatingStarIndex = StateProvider.autoDispose<int>((ref) {
  return -1;
});
