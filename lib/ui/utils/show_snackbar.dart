import 'package:flutter/material.dart';

showSnackBar({
  required BuildContext context,
  required String text,
  Color? backgroundColor,
  int milisecondsDuration = 700,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(milliseconds: milisecondsDuration),
      backgroundColor: backgroundColor,
    ),
  );
}
