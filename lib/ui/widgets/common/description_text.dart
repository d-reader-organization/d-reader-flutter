import 'package:flutter/material.dart';

class DescriptionText extends StatelessWidget {
  final String text;
  const DescriptionText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium,
      textAlign: TextAlign.start,
    );
  }
}
