import 'package:flutter/material.dart' show ValueNotifier;
import 'package:flutter_hooks/flutter_hooks.dart';

ValueNotifier<GlobalState> useGlobalState<T>() {
  final result = useState<GlobalState>(const GlobalState(isLoading: false));
  return result;
}

class GlobalState {
  const GlobalState({
    required this.isLoading,
    this.showSplash = false,
  });
  final bool isLoading;
  final bool showSplash;

  GlobalState copyWith({required bool isLoading, bool showSplash = false}) {
    return GlobalState(isLoading: isLoading, showSplash: showSplash);
  }
}
