import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

showSnackBar({
  required BuildContext context,
  required String text,
  Color backgroundColor = ColorPalette.greyscale300,
  int milisecondsDuration = 3600,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(
        milliseconds: milisecondsDuration,
      ),
      backgroundColor: backgroundColor,
    ),
  );
}
