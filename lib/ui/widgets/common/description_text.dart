import 'package:flutter/material.dart';

class DescriptionText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final int maxLines;
  const DescriptionText({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.maxLines = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: .2,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
