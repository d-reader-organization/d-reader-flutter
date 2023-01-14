import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable // preferred to use immutable states
class SearchState {
  const SearchState({required this.search, required this.searchController});
  final TextEditingController searchController;
  final String search;

  SearchState copyWith({required String search}) {
    return SearchState(search: search, searchController: searchController);
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>(
    (ref) => SearchNotifier());

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier()
      : super(
            SearchState(search: '', searchController: TextEditingController()));

  @override
  void dispose() {
    state.searchController.dispose();
    super.dispose();
  }

  updateSearchValue(String newValue) async {
    state = state.copyWith(search: newValue);
  }
}
