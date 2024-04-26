import 'package:d_reader_flutter/shared/presentations/providers/global/state/global_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:package_info_plus/package_info_plus.dart';

ValueNotifier<GlobalState> useGlobalState<T>() {
  final result = useState<GlobalState>(const GlobalState(isLoading: false));
  return result;
}

final privateLoadingProvider = StateProvider<bool>(
  (ref) {
    return false;
  },
);

final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return await PackageInfo.fromPlatform();
});

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

final bookmarkSelectedProvider = StateProvider.family.autoDispose<bool, bool>(
  (ref, arg) {
    return arg;
  },
);
