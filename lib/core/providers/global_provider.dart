import 'package:flutter/material.dart' show ValueNotifier;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

ValueNotifier<GlobalState> useGlobalState<T>() {
  final result = useState<GlobalState>(const GlobalState(isLoading: false));
  return result;
}

class GlobalState {
  const GlobalState({
    required this.isLoading,
    this.isReferred = false,
    this.isMinting,
  });
  final bool isLoading, isReferred;
  final bool? isMinting;

  GlobalState copyWith({
    required bool isLoading,
    bool? isMinting,
    bool isReferred = false,
  }) {
    return GlobalState(
      isLoading: isLoading,
      isMinting: isMinting,
      isReferred: isReferred,
    );
  }
}

final globalStateProvider = StateProvider(
  (ref) => const GlobalState(
    isLoading: false,
  ),
);

final privateLoadingProvider = StateProvider<bool>(
  (ref) {
    return false;
  },
);

final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return await PackageInfo.fromPlatform();
});
