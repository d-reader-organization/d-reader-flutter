import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable // preferred to use immutable states
class HomeState {
  const HomeState({
    required this.counter,
  });
  final int counter;

  HomeState copyWith({required int counter}) {
    return HomeState(counter: counter);
  }
}

final homeProvider =
    StateNotifierProvider<HomeNotifier, HomeState>((ref) => HomeNotifier());

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState(counter: 0));

  incrementCounter() async {
    state = state.copyWith(counter: state.counter + 1);
  }
}
