import 'package:d_reader_flutter/core/providers/search_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchBarSliver extends ConsumerWidget {
  const SearchBarSliver({Key? key}) : super(key: key);

  void _submitHandler(WidgetRef ref) {
    String search = ref.read(searchProvider).searchController.text.trim();
    ref.read(searchProvider.notifier).updateSearchValue(search);
    ref.read(searchProvider).searchController.clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      sliver: SliverAppBar(
        backgroundColor: ColorPalette.appBackgroundColor,
        title: TextFormField(
          controller: ref.read(searchProvider).searchController,
          textInputAction: TextInputAction.search,
          cursorColor: Colors.white,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.white,
          ),
          decoration: searchInputDecoration(
            IconButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                _submitHandler(ref);
              },
              icon: const Icon(
                Icons.search,
                color: ColorPalette.dReaderGrey,
              ),
            ),
          ),
          onFieldSubmitted: (value) {
            _submitHandler(ref);
          },
        ),
      ),
    );
  }
}
