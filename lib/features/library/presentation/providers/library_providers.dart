import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedTabIndex = StateProvider.autoDispose<int>((ref) {
  return 1;
});
