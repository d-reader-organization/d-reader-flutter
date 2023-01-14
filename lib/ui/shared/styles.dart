import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

InputDecoration searchInputDecoration(Widget prefixIcon) {
  return InputDecoration(
    fillColor: ColorPalette.boxBackground200,
    filled: true,
    border: OutlineInputBorder(
      borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      borderRadius: BorderRadius.circular(
        16.0,
      ),
    ),
    hintText: 'Search',
    hintStyle: const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: ColorPalette.dReaderGrey,
    ),
    prefixIcon: prefixIcon,
    suffixIcon: const Icon(
      Icons.linear_scale_sharp,
      // Icons.drag_handle_outlined ??
      // Icons.commit,
      color: ColorPalette.dReaderYellow100,
    ),
  );
}
