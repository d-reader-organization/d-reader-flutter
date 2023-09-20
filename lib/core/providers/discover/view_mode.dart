import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ViewMode {
  gallery,
  detailed,
}

final viewModeProvider = StateProvider<ViewMode>((ref) {
  final String? existingKey = LocalStore.instance.get(viewModeStoreKey);
  return existingKey != null && existingKey == ViewMode.gallery.name
      ? ViewMode.gallery
      : ViewMode.detailed;
});
