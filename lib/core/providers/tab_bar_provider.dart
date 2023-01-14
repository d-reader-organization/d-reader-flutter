import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable // preferred to use immutable states
class TabBarState {
  const TabBarState({
    required this.selectedTabIndex,
  });
  final int selectedTabIndex;

  TabBarState copyWith({required int index}) {
    return TabBarState(selectedTabIndex: index);
  }
}

final tabBarProvider = StateNotifierProvider<TabBarNotifier, TabBarState>(
    (ref) => TabBarNotifier());

class TabBarNotifier extends StateNotifier<TabBarState> {
  TabBarNotifier() : super(const TabBarState(selectedTabIndex: 0));

  setTabIndex(int index) {
    state = state.copyWith(index: index);
  }
}
