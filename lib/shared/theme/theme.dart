import 'package:flutter/material.dart';

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
