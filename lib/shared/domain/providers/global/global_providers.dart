import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';

final isAppBarVisibleProvider = StateProvider<bool>((ref) {
  return true;
});

final bookmarkLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

final viewModeProvider = StateProvider<ViewMode>((ref) {
  final String? existingKey = LocalStore.instance.get(viewModeStoreKey);
  return existingKey != null && existingKey == ViewMode.detailed.name
      ? ViewMode.detailed
      : ViewMode.gallery;
});

final obscureTextProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

final additionalObscureTextProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});
