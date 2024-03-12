import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class SearchState {
  const SearchState({required this.search, required this.searchController});
  final TextEditingController searchController;
  final String search;

  SearchState copyWith({required String search}) {
    return SearchState(search: search, searchController: searchController);
  }
}

class SearchNotifier extends Notifier<SearchState> {
  @override
  SearchState build() {
    return SearchState(search: '', searchController: TextEditingController());
  }

  void updateSearchValue(String newValue) {
    state = state.copyWith(search: newValue);
  }
}

final searchProvider = NotifierProvider<SearchNotifier, SearchState>(
  SearchNotifier.new,
);
