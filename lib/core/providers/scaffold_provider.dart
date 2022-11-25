import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable // preferred to use immutable states
class ScaffoldState {
  const ScaffoldState({
    required this.navigationIndex,
  });
  final int navigationIndex;

  ScaffoldState copyWith({required int index}) {
    return ScaffoldState(navigationIndex: index);
  }
}

final scaffoldProvider = StateNotifierProvider<ScaffoldNotifier, ScaffoldState>(
    (ref) => ScaffoldNotifier());

final scaffoldPageController = Provider.autoDispose<PageController>((ref) {
  final PageController pageController = PageController();
  ref.onDispose(() {
    pageController.dispose();
  });

  return pageController;
});

class ScaffoldNotifier extends StateNotifier<ScaffoldState> {
  ScaffoldNotifier() : super(const ScaffoldState(navigationIndex: 0));

  setNavigationIndex(int index) {
    state = state.copyWith(index: index);
  }
}
