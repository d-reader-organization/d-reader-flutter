import 'package:flutter/material.dart';

showSnackBar({
  required BuildContext context,
  required String text,
  Color? backgroundColor,
  int duration = 700,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(milliseconds: duration),
      backgroundColor: backgroundColor,
    ),
  );
}
