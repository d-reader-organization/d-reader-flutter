import 'package:flutter/material.dart';

class DescriptionText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  const DescriptionText({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: textAlign,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
