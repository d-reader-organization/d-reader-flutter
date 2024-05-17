import 'package:flutter/material.dart';

double calcPageImageHeight({
  required BuildContext context,
  required int imageHeight,
  required int imageWidth,
}) {
  double divisor = .66;
  if (imageWidth > 0 && imageHeight > 0) {
    divisor = imageWidth / imageHeight;
  }
  return MediaQuery.sizeOf(context).width / divisor;
}
