import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchBar extends ConsumerWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      cursorColor: dReaderYellow,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: dReaderYellow,
      ),
      decoration: InputDecoration(
        fillColor: dReaderDarkGrey,
        filled: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          borderRadius: BorderRadius.circular(
            16.0,
          ),
        ),
        labelText: AppLocalizations.of(context)?.search ?? 'Search',
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: dReaderGrey,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: dReaderGrey,
        ),
        suffixIcon: const Icon(
          Icons.linear_scale_sharp,
          // Icons.drag_handle_outlined ??
          // Icons.commit,
          color: dReaderYellow,
        ),
      ),
    );
  }
}
