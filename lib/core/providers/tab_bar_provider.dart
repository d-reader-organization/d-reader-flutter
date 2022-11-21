import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable // preferred to use immutable states
class TabBarState {
  const TabBarState({
    required this.initialIndex,
  });
  final int initialIndex;

  TabBarState copyWith({required int index}) {
    return TabBarState(initialIndex: index);
  }
}

final tabBarProvider = StateNotifierProvider<TabBarNotifier, TabBarState>(
    (ref) => TabBarNotifier());

class TabBarNotifier extends StateNotifier<TabBarState> {
  TabBarNotifier() : super(const TabBarState(initialIndex: 0));

  setInitialIndex(int index) {
    state = state.copyWith(index: index);
  }
}
