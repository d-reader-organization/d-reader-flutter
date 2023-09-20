import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ViewMode {
  gallery,
  detailed,
}

final viewModeProvider = StateProvider<ViewMode>((ref) {
  return ViewMode.detailed;
});
