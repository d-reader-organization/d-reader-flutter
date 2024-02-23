import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

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

TextTheme getTextTheme() {
  return const TextTheme(
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  );
}
