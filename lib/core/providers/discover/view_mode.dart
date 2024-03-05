import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ViewMode {
  gallery,
  detailed,
}

final viewModeProvider = StateProvider<ViewMode>((ref) {
  final String? existingKey = LocalStore.instance.get(viewModeStoreKey);
  return existingKey != null && existingKey == ViewMode.detailed.name
      ? ViewMode.detailed
      : ViewMode.gallery;
});
