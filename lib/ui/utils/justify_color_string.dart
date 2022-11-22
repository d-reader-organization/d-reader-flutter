import 'package:flutter/material.dart' show Color;

Color getColorFromGenreString(String color) {
  color = color.replaceAll('#', '');
  if (color.length == 3) {
    color = color.split('').map((e) => '$e$e').join('');
  }
  return Color(
    int.parse('0xFF$color'),
  );
}
