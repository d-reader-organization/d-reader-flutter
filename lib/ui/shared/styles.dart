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

/* 
bodySmall: 14, w500
bodyMedium: 16, w500,
bodyLarge: 18, w500,

titleSmall: 14, w700,
titleMedium: 16, w700
titleLarge: 18, w700

labelSmall: 12, w700
labelMedium: 14, w700
labelLarge: 16, w700,


*/

TextTheme getTextTheme() {
  return const TextTheme(
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
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
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  );
}
