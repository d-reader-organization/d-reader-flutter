import 'package:flutter/material.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';

InputDecoration searchInputDecoration({
  Widget? prefixIcon,
  String hintText = 'Search',
  Widget? suffixIcon,
}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(16),
    fillColor: ColorPalette.greyscale500,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1,
        color: ColorPalette.greyscale300,
      ),
      borderRadius: BorderRadius.circular(
        8,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1,
        color: ColorPalette.dReaderYellow100,
      ),
      borderRadius: BorderRadius.circular(
        8,
      ),
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1,
        color: ColorPalette.greyscale300,
      ),
      borderRadius: BorderRadius.circular(
        8,
      ),
    ),
    hintText: hintText,
    hintStyle: const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: ColorPalette.greyscale200,
    ),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
  );
}
