import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/shared/styles.dart';
import 'package:flutter/material.dart';

class SearchBarSliver extends StatelessWidget {
  const SearchBarSliver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      sliver: SliverAppBar(
        backgroundColor: ColorPalette.appBackgroundColor,
        title: TextField(
          cursorColor: ColorPalette.dReaderYellow100,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: ColorPalette.dReaderYellow100,
          ),
          decoration: searchInputDecoration,
        ),
      ),
    );
  }
}
