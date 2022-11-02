import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable // preferred to use immutable states
class SearchState {
  const SearchState({
    required this.counter,
  });

  final int counter;
  SearchState copyWith({required int counter}) {
    return SearchState(counter: counter);
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>(
    (ref) => SearchNotifier());

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState(counter: 0));

  triggerSearch() async {
    // TODO - add api call, update data etc.
    state = state.copyWith(counter: state.counter + 1);
  }
}
